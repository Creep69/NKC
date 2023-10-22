from ctypes.wintypes import DOUBLE
import time,sys
import serial
import os
from optparse import OptionParser
import ntpath

from serial.serialutil import SerialTimeoutException, Timeout


BlockSize = 256
class Crc16:
    def __init__(self, poly=0x1021):
        self.POLYNOMIAL = poly & 0xFFFF
        self.__initCRC_Table()
        self.crc = 0xffff
    def __initCRC_Table(self):
        self.crc_table = []
        for b in range(256):
            v = b << 8
            for i in range(8):
                if ( (v & 0x8000) != 0x0000 ):
                    v = ( v << 1 ) ^ self.POLYNOMIAL
                else:
                    v = v << 1
            #print("%d = 0x%X" % (b,v))
            self.crc_table.append(v & 0xFFFF)
    def start_CRC(self,start_value=0xffff):
        self.crc = start_value
    def update_crc(self,b):
        self.crc = ((self.crc << 8) ^ self.crc_table[(self.crc >> 8) ^ (b)]) & 0xffff
    def update_crc16(self,w):
        self.crc=self.update_crc((w&0xff))
        self.crc=self.update_crc((w>>8)&0xff)
    def calc_crc(self,frame,start_value=0xffff):
        self.start_CRC(start_value)
        for i in range(len(frame)):
            self.update_crc(frame[i])
        return self.get_crc()
    def get_crc(self):
        return self.crc

class ser_file_transfer:
    def __init__(self, options, block_size=256):
        self.block_size = block_size
        assert(((block_size & 0xFF)==0) and (block_size>0))
        self.crc=Crc16()
        self.status = 0
        self.ser = serial.Serial(
            port=options.port,
            baudrate=options.baud,
            parity=serial.PARITY_NONE,
            stopbits=serial.STOPBITS_ONE,
            bytesize=serial.EIGHTBITS,
            timeout=10
            #SerialTimeoutException
        )
        print("Initialized %s for %d Baud"%(options.port, options.baud))
        self.ser.isOpen()
    def send_header(self, file_name, file_size):
        header=bytearray()
        # overall frame format:
        # <len><payload><CRC>
        # Transfer Header (Frame 0):
        # <len:1><H:1><bs:1><fs:4><fn><0><CRC:2>
        #header_len= 2+1+1+4+len(file_name)+1+2
        #header.extend(header_len.to_bytes(2,'big'))                 # Len: 2
        header.extend(map(ord, 'H'))                                # 'H': 1
        header.extend(int(self.block_size/256).to_bytes(1,'little'))   # bs : 1
        header.extend(file_size.to_bytes(4,'big'))               # fs: 4
        header.extend(map(ord, ntpath.basename(file_name)))        # file_name: <16
        terminator=0                                                # Terminator                        
        header.extend(terminator.to_bytes(1,'little'))              # zero : 1
        # calculate CRC of Header
        #header.extend(self.crc.calc_crc(header).to_bytes(2,'big'))   # CRC: 2
        #sent=self.ser.write(header)
        #assert(sent==header_len)
        #if (self.ser.read(1)!=b'O'):
        self.status= self.send_frame(header)
        return self.status
    def send_frame(self, data):
        #crc_value=0xffff
        assert(len(data)<=self.block_size)
        for tries in range(5):
            self.crc.start_CRC(0xFFFF)
            frame=bytearray()
            # overall frame format:
            # <len><payload><CRC>
            frame_len= 2+len(data)+2
            frame.extend(frame_len.to_bytes(2,'big'))                 # Len: 2
            frame.extend(data)
            frame.extend(self.crc.calc_crc(frame).to_bytes(2,'big'))   # CRC: 2
            sent=self.ser.write(frame)
            assert(sent==frame_len)
            if (self.ser.read(1)!=b'O'):
                sys.stdout.write('!')
                sys.stdout.flush()
                self.status=1
            else:
                sys.stdout.write('.')
                sys.stdout.flush()
                self.status=0
                break
        return self.status

    def receive_frame(self):
        retries=0
        self.status=1
        data=None
        while retries<5:
            #self.crc.start_CRC(0xFFFF)
            # overall frame format:
            # <len><payload><CRC>
            fs=self.ser.read(2)
            nr_bytes = int.from_bytes(fs,byteorder='big')
            #print("%d Bytes to transfer" % (nr_bytes))
            
            if nr_bytes>0:
                frame=bytearray()
                frame.extend(fs)
                # 3. Read payload+CRC
                data=self.ser.read(nr_bytes-2)
                frame.extend(data)
                if self.crc.calc_crc(frame)==0:
                    sys.stdout.write('.')
                    sys.stdout.flush()
                    self.ser.write(b'O')
                    self.status=0
                    break
                else:
                    sys.stdout.write('!')
                    sys.stdout.flush()
                    self.ser.write(b'N')
                    retries +=1
        return data[0:nr_bytes-4]
    def check_slave_available(self):
        for retry in range(5):
            self.ser.write(b'!')
            if (self.ser.read(1)==b'?'):
                return 0
            print("timeout - try %d" % (retry))
        return 1
    def send_file(self,file_name):
        file_size = os.stat(file_name).st_size
        nr_blocks = int((file_size+self.block_size-1)/self.block_size)
        file_content=bytearray()
        with open(file_name, "rb") as f:
            bytes_read = f.read()
            file_content.extend(bytes_read)
        if file_name[-4:] in [".asm",".txt"]:
            terminator =0
            file_content.extend(terminator.to_bytes(1,'little'))              # zero : 1
            file_size +=1
        if self.check_slave_available()!=0:
            print("Serial slave not available")
            return 1
        # read file
        
        self.ser.write(b'D') # Download Command
        # Wait for ACK
        while True:
            if (self.ser.read(1)==b'O'):
                break
        if self.send_header(file_name,file_size)!=0:
            print("Error sending Header")

        block_nr=0
        while block_nr<nr_blocks:
            idx1=block_nr*self.block_size
            idx2=min((block_nr+1)*self.block_size,file_size)
            if self.send_frame(file_content[idx1:idx2])!=0:
                print("Error transmitting file")
                return 1
            block_nr +=1
        assert(block_nr==nr_blocks)
        print("Done. CRC OK")
        return 0
    def convert_text_file(self,fc):
        for i in range(len(fc)):
            if fc[i]==0:
                return fc[0:i]
        return fc
    def receive_file(self,file_name):
        if self.check_slave_available()!=0:
            print("Serial slave not available")
            return 1
        self.ser.write(b'U') # Upload Command
        # Wait for ACK
        while True:
            if (self.ser.read(1)==b'O'):
                break
        if self.send_header(file_name,0)!=0:
            print("Error sending Header")
        
        frame = self.receive_frame()
        if frame ==None or len(frame)==0:
            print("Error receiving Filesize")
        #print(len(frame))
        nr_bytes = int.from_bytes(frame,byteorder='big')
        if nr_bytes==0:
            print ("%s not found. abort" % (file_name))
            return 2
        print("Receiving %s, length: %d Bytes" % (file_name, nr_bytes))
        nr_blocks = int((nr_bytes+self.block_size-1)/self.block_size)
        block_nr=0
        file=bytearray()
        while block_nr<nr_blocks:
            frame=self.receive_frame()
            if frame ==None or len(frame)==0:
                print("Error receiving file content")
                return 3
            block_nr +=1
            file.extend(frame)
        if block_nr<nr_blocks:
            print("Transfer aborted because of too many errors")
            return 1
        
        if file_name[-4:] in [".asm",".txt"]:
            file=self.convert_text_file(file)
        fn= file_name    
        if fn[1]==":":
            fn=file_name[2:]
        with open(fn, "wb") as f:
            #bytes_read = f.read()
            f.write(file)
        print("Done. CRC OK")
    def send_bl_command(self):
        sent=self.ser.write(b"\r\nW\r\n");
        if self.ser.in_waiting>0:
            temp = self.ser.read(self.ser.in_waiting)
            print(temp)
        iterations=0
        success=False
        while iterations<100:
            sent=self.ser.write(b'!');
            xy=self.ser.read(1);
            if xy==b'?':
                success=True
                break
        return success


print("NKC-Downloader by AVG")
parser = OptionParser()
parser.add_option("-d", "--download", dest="download", help="file to download", metavar = "FILE") #, default="1:rs232d.asm")
parser.add_option("-u", "--upload", dest="upload", help="file to uploadload", metavar = "FILE") #, default="1:rs232d.asm")
parser.add_option("-p", "--port", dest="port", help="COM-port", default="COM1")
parser.add_option("-b", "--baud", dest="baud", help="Baudrate", default=19200, type=int )
parser.add_option("-w", "--write", dest="boot", help="Start bootloader", default=False, action="store_true" )
#parser.add_option("-r", "--receive", dest="receive", help="Receive Mode", default=True )
(options, args) = parser.parse_args()

#print(options.filename)
if (not (options.download or options.upload)):
    print("Invalid filename given")
    sys.exit()
ft = ser_file_transfer(options)
if (options.boot):
    if(ft.send_bl_command()==False):
        print("Failed to start Bootloader!")
        exit
if (options.upload != None):
    ft.send_file(options.upload)
if (options.download != None):
    ft.receive_file(options.download)



