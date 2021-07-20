RS232 Up/Downloader V0.5 20.07.2021
(C) Andreas Voggeneder
Beta Version

Dieses Programm dient zum transfer von Dateien zwischen PC und NKC mittels RS232 Schinttstelle.
Am NKC läuft dazu ein Slave der die Read/Write Kommandos vom PC entgegennimmt und ausführt.
Die Datenübertragung wird dabei blockorientiert (256byte Blöcke) die jeweils mit einer CRC16 geschützt sind ausgeführt.
Jeder Block wird einzeln übertragen und vom empfänger geprüft ob die CRC stimmt und dann bestätigt (ACK) oder erneut angefordert (NACK)
Am PC wird dazu ein Python-Host Programm gestartet das mit dem Slave der am NKC läuft Verbindung aufnimmt und den Trabsfer durchführt.

"python dl.py --help" gibt eine Übersicht über alle möglichen parameter aus.

Assembler: Grundprogramm

Beispiel:
(I) Senden einer Datei zum NKC:
1. Starten des Slaves am NKC (mit 57600 Baud)
   rs232d 57600

2. Senden der Datei vom PC
   python dl.py -p com1 -b 57600 -u hello.68k

3. sollen keine weiteren dateien mehr übertragen werden kann der Slave am NKC mit der taste 'x' beeinden werden.
Die empfangenen files sollten dann im aktuellen Laufwerk liegen

(II) Empfangen einer Datei vom NKC:
1. Starten des Slaves am NKC (mit 57600 Baud)
   rs232d 57600

2. Empfangen der Datei am PC
   python dl.py -p com1 -b 57600 -d 1:rs232d.asm
   

Default (ohne commandline parameter) ist auf beiden Seiten (PC und NKC) 19200 Baud welches die max. mögliche Baudrate auf der alten Ser (6551 Uart) ist. 
Mit der GDP-FPGA sind max. 57600 Baud möglich

ACHTUNG:
********
Auf Performance-Gründen musste ich auf die SER-Register direkt zugreifen. Die Grundprogramm Traps waren dafür zu langsam.
Desswegen muss die Ser-Basis-Addresse und CPU-Typ vor dem assemblieren korrekt eingestellt werden. Default ist eine 68000 CPU (16bit)
sowie eine Basisaddresse der SER von 0xFFF0 

        CPU equ 2       ;

        ser_base equ $fff0

Wenn der Transfer nicht funktioniert kann es ev. an den RTS/CTS Leitungen liegen. Diese werden aktuell nicht verwendet jedoch hat der 6551 UART 
der in der original-Ser verwendet wird einen nicht abschaltbaren HW-Handshake


Installation Python 3.9
***********************
1.) Python 3.9 aus Microsoft Store runter laden und installieren
  oder optional von hier (Python 3.9.5): https://www.python.org/downloads/release/python-395/

2.) Fehlende Python Module installieren
   Windows Terminal öffnen und folgende Befehle eingeben:
   - pip install serial
   - pip install pyserial
Generell können in Python fehlende Module mit dem Python Packet Manager (pip) einfach nachinstalliert werden   

  
