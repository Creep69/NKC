EESchema Schematic File Version 2
LIBS:power
LIBS:device
LIBS:transistors
LIBS:conn
LIBS:linear
LIBS:regul
LIBS:74xx
LIBS:cmos4000
LIBS:adc-dac
LIBS:memory
LIBS:xilinx
LIBS:microcontrollers
LIBS:dsp
LIBS:microchip
LIBS:analog_switches
LIBS:motorola
LIBS:texas
LIBS:intel
LIBS:audio
LIBS:interface
LIBS:digital-audio
LIBS:philips
LIBS:display
LIBS:cypress
LIBS:siliconi
LIBS:opto
LIBS:atmel
LIBS:contrib
LIBS:valves
LIBS:nkc
LIBS:platinen
LIBS:switches
LIBS:SymbolsSimilarEn60617-RevE4
LIBS:74xx-eu
LIBS:ioe_enh-cache
EELAYER 25 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title "NDR NKC IOE - Enhanced"
Date "2017-04-28"
Rev "1.0"
Comp "Marcel André"
Comment1 "Schnittstellenbaugruppe für NDR Klein Computer"
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L CONN_01X36 ST1
U 1 1 58D96073
P 1350 2850
F 0 "ST1" H 1350 4700 50  0000 C CNN
F 1 "CONN_01X36" V 1450 2850 50  0000 C CNN
F 2 "nkc:NKC_BUS_36" H 1350 2850 50  0001 C CNN
F 3 "" H 1350 2850 50  0000 C CNN
	1    1350 2850
	1    0    0    -1  
$EndComp
Entry Wire Line
	800  1300 900  1400
Entry Wire Line
	800  1400 900  1500
Entry Wire Line
	800  1500 900  1600
Entry Wire Line
	800  1600 900  1700
Entry Wire Line
	800  1700 900  1800
Entry Wire Line
	800  1800 900  1900
Entry Wire Line
	800  1900 900  2000
Entry Wire Line
	800  2000 900  2100
Text Label 950  1400 0    60   ~ 0
+5V
Text Label 950  1500 0    60   ~ 0
+5V
Text Label 950  1600 0    60   ~ 0
GND
Text Label 950  1700 0    60   ~ 0
GND
Entry Wire Line
	800  2100 900  2200
Entry Wire Line
	800  2200 900  2300
Entry Wire Line
	800  2300 900  2400
Entry Wire Line
	800  2400 900  2500
Text Label 1000 1800 0    60   ~ 0
D0
Text Label 1000 1900 0    60   ~ 0
D1
Text Label 1000 2000 0    60   ~ 0
D2
Text Label 1000 2100 0    60   ~ 0
D3
Text Label 1000 2200 0    60   ~ 0
D4
Text Label 1000 2300 0    60   ~ 0
D5
Text Label 1000 2400 0    60   ~ 0
D6
Text Label 1000 2500 0    60   ~ 0
D7
Entry Wire Line
	800  2500 900  2600
Entry Wire Line
	800  2600 900  2700
Text Label 950  2600 0    60   ~ 0
/RD
Text Label 950  2700 0    60   ~ 0
/WR
Entry Wire Line
	800  2700 900  2800
Entry Wire Line
	800  2900 900  3000
Entry Wire Line
	800  3000 900  3100
Entry Wire Line
	800  3300 900  3400
Entry Wire Line
	800  3400 900  3500
Entry Wire Line
	800  3500 900  3600
Entry Wire Line
	800  3600 900  3700
Text Label 900  2800 0    60   ~ 0
/IORQ
Text Label 1000 3000 0    60   ~ 0
A0
Text Label 1000 3100 0    60   ~ 0
A1
Text Label 1000 3400 0    60   ~ 0
A4
Text Label 1000 3500 0    60   ~ 0
A5
Text Label 1000 3600 0    60   ~ 0
A6
Text Label 1000 3700 0    60   ~ 0
A7
$Comp
L CP C1
U 1 1 58DEA5C6
P 1450 5250
F 0 "C1" H 1475 5350 50  0000 L CNN
F 1 "10µF" H 1475 5150 50  0000 L CNN
F 2 "Capacitors_ThroughHole:C_Radial_D5_L6_P2.5" H 1488 5100 50  0001 C CNN
F 3 "" H 1450 5250 50  0000 C CNN
	1    1450 5250
	1    0    0    -1  
$EndComp
$Comp
L PWR_FLAG #FLG01
U 1 1 58DEAC60
P 1050 4950
F 0 "#FLG01" H 1050 5045 50  0001 C CNN
F 1 "PWR_FLAG" H 1050 5130 50  0000 C CNN
F 2 "" H 1050 4950 50  0000 C CNN
F 3 "" H 1050 4950 50  0000 C CNN
	1    1050 4950
	1    0    0    -1  
$EndComp
$Comp
L VCC #PWR02
U 1 1 58DEACA0
P 1600 5050
F 0 "#PWR02" H 1600 4900 50  0001 C CNN
F 1 "VCC" H 1600 5200 50  0000 C CNN
F 2 "" H 1600 5050 50  0000 C CNN
F 3 "" H 1600 5050 50  0000 C CNN
	1    1600 5050
	0    1    1    0   
$EndComp
Text Label 1100 5050 0    60   ~ 0
+5V
$Comp
L GND #PWR03
U 1 1 58DEACF3
P 1600 5500
F 0 "#PWR03" H 1600 5250 50  0001 C CNN
F 1 "GND" H 1600 5350 50  0000 C CNN
F 2 "" H 1600 5500 50  0000 C CNN
F 3 "" H 1600 5500 50  0000 C CNN
	1    1600 5500
	0    -1   -1   0   
$EndComp
$Comp
L PWR_FLAG #FLG04
U 1 1 58DEAD2F
P 1050 5350
F 0 "#FLG04" H 1050 5445 50  0001 C CNN
F 1 "PWR_FLAG" H 1050 5530 50  0000 C CNN
F 2 "" H 1050 5350 50  0000 C CNN
F 3 "" H 1050 5350 50  0000 C CNN
	1    1050 5350
	1    0    0    -1  
$EndComp
Text Label 1100 5500 0    60   ~ 0
GND
$Comp
L CONN_02X20 ST2
U 1 1 58DEB4AF
P 9900 2600
F 0 "ST2" H 9900 3650 50  0000 C CNN
F 1 "CONN_02X20" V 9900 2600 50  0000 C CNN
F 2 "Pin_Headers:Pin_Header_Straight_2x20" H 9900 1650 50  0001 C CNN
F 3 "" H 9900 1650 50  0000 C CNN
	1    9900 2600
	1    0    0    -1  
$EndComp
Entry Wire Line
	800  4950 900  5050
Entry Wire Line
	800  5400 900  5500
$Comp
L 74LS245 J2
U 1 1 58DEB9E0
P 7650 1600
F 0 "J2" H 7600 2050 50  0000 L BNN
F 1 "74LS245" H 7500 1150 50  0000 L TNN
F 2 "Housings_DIP:DIP-20_W7.62mm_LongPads" H 7650 1600 50  0001 C CNN
F 3 "" H 7650 1600 50  0000 C CNN
	1    7650 1600
	1    0    0    -1  
$EndComp
$Comp
L 74LS245 J3
U 1 1 58DEBA72
P 7650 2850
F 0 "J3" H 7600 3250 50  0000 L BNN
F 1 "74LS245" H 7500 2400 50  0000 L TNN
F 2 "Housings_DIP:DIP-20_W7.62mm_LongPads" H 7650 2850 50  0001 C CNN
F 3 "" H 7650 2850 50  0000 C CNN
	1    7650 2850
	1    0    0    -1  
$EndComp
$Comp
L 74LS374 J4
U 1 1 58DEBACF
P 7650 4100
F 0 "J4" H 7650 4100 50  0000 C CNN
F 1 "74LS374" H 7700 3750 50  0000 C CNN
F 2 "Housings_DIP:DIP-20_W7.62mm_LongPads" H 7650 4100 50  0001 C CNN
F 3 "" H 7650 4100 50  0000 C CNN
	1    7650 4100
	1    0    0    -1  
$EndComp
$Comp
L 74LS374 J5
U 1 1 58DEBB3C
P 7650 5350
F 0 "J5" H 7650 5350 50  0000 C CNN
F 1 "74LS374" H 7700 5000 50  0000 C CNN
F 2 "Housings_DIP:DIP-20_W7.62mm_LongPads" H 7650 5350 50  0001 C CNN
F 3 "" H 7650 5350 50  0000 C CNN
	1    7650 5350
	1    0    0    -1  
$EndComp
$Comp
L 74LS139 J6
U 1 1 58DEC0FE
P 3750 1900
F 0 "J6" H 3750 2000 50  0000 C CNN
F 1 "74LS139" H 3750 1800 50  0000 C CNN
F 2 "Housings_DIP:DIP-16_W7.62mm_LongPads" H 3750 1900 50  0001 C CNN
F 3 "" H 3750 1900 50  0000 C CNN
	1    3750 1900
	0    1    -1   0   
$EndComp
$Comp
L 74LS139 J6
U 2 1 58DEC171
P 4650 1900
F 0 "J6" H 4650 2000 50  0000 C CNN
F 1 "74LS139" H 4650 1800 50  0000 C CNN
F 2 "Housings_DIP:DIP-16_W7.62mm_LongPads" H 4650 1900 50  0001 C CNN
F 3 "" H 4650 1900 50  0000 C CNN
	2    4650 1900
	0    1    -1   0   
$EndComp
$Comp
L 74LS32 J8
U 4 1 58DEC2BB
P 4200 3300
F 0 "J8" H 4200 3350 50  0000 C CNN
F 1 "74LS32" H 4200 3250 50  0000 C CNN
F 2 "Housings_DIP:DIP-14_W7.62mm_LongPads" H 4200 3300 50  0001 C CNN
F 3 "" H 4200 3300 50  0000 C CNN
	4    4200 3300
	-1   0    0    1   
$EndComp
$Comp
L 74LS32 J8
U 3 1 58DEC344
P 4200 3750
F 0 "J8" H 4200 3800 50  0000 C CNN
F 1 "74LS32" H 4200 3700 50  0000 C CNN
F 2 "Housings_DIP:DIP-14_W7.62mm_LongPads" H 4200 3750 50  0001 C CNN
F 3 "" H 4200 3750 50  0000 C CNN
	3    4200 3750
	-1   0    0    1   
$EndComp
NoConn ~ 1000 2900
NoConn ~ 1000 3800
NoConn ~ 1000 3900
NoConn ~ 1000 4000
NoConn ~ 1000 4100
NoConn ~ 1000 4200
NoConn ~ 1000 4300
NoConn ~ 1000 4400
NoConn ~ 1000 4500
NoConn ~ 1000 4600
NoConn ~ 1000 1100
NoConn ~ 1000 1200
NoConn ~ 1000 1300
Entry Wire Line
	6000 3200 6100 3300
Text Label 5800 3200 0    60   ~ 0
/RD
Entry Wire Line
	6000 2950 6100 3050
Entry Wire Line
	6100 1000 6200 1100
Text Label 5850 2950 0    60   ~ 0
A0
NoConn ~ 3450 950 
NoConn ~ 3650 950 
NoConn ~ 4350 950 
NoConn ~ 4550 950 
Text Label 6250 1100 0    60   ~ 0
D0
Entry Wire Line
	6100 1100 6200 1200
Entry Wire Line
	6100 1200 6200 1300
Entry Wire Line
	6100 1300 6200 1400
Entry Wire Line
	6100 1400 6200 1500
Entry Wire Line
	6100 1500 6200 1600
Entry Wire Line
	6100 1600 6200 1700
Entry Wire Line
	6100 1700 6200 1800
Entry Wire Line
	6100 1900 6200 2000
Text Label 6200 2000 0    60   ~ 0
/RD
Text Label 6250 1200 0    60   ~ 0
D1
Text Label 6250 1300 0    60   ~ 0
D2
Text Label 6250 1400 0    60   ~ 0
D3
Text Label 6250 1500 0    60   ~ 0
D4
Text Label 6250 1600 0    60   ~ 0
D5
Text Label 6250 1700 0    60   ~ 0
D6
Text Label 6250 1800 0    60   ~ 0
D7
Entry Wire Line
	6100 2250 6200 2350
Text Label 6250 2350 0    60   ~ 0
D0
Entry Wire Line
	6100 2350 6200 2450
Entry Wire Line
	6100 2450 6200 2550
Entry Wire Line
	6100 2550 6200 2650
Entry Wire Line
	6100 2650 6200 2750
Entry Wire Line
	6100 2750 6200 2850
Entry Wire Line
	6100 2850 6200 2950
Entry Wire Line
	6100 2950 6200 3050
Entry Wire Line
	6100 3150 6200 3250
Text Label 6200 3250 0    60   ~ 0
/RD
Text Label 6250 2450 0    60   ~ 0
D1
Text Label 6250 2550 0    60   ~ 0
D2
Text Label 6250 2650 0    60   ~ 0
D3
Text Label 6250 2750 0    60   ~ 0
D4
Text Label 6250 2850 0    60   ~ 0
D5
Text Label 6250 2950 0    60   ~ 0
D6
Text Label 6250 3050 0    60   ~ 0
D7
Entry Wire Line
	6100 3500 6200 3600
Entry Wire Line
	6100 3600 6200 3700
Entry Wire Line
	6100 3700 6200 3800
Entry Wire Line
	6100 3800 6200 3900
Entry Wire Line
	6100 3900 6200 4000
Entry Wire Line
	6100 4000 6200 4100
Entry Wire Line
	6100 4100 6200 4200
Entry Wire Line
	6100 4200 6200 4300
Entry Wire Line
	6100 4750 6200 4850
Text Label 6250 4850 0    60   ~ 0
D1
Entry Wire Line
	6100 4850 6200 4950
Entry Wire Line
	6100 4950 6200 5050
Entry Wire Line
	6100 5050 6200 5150
Entry Wire Line
	6100 5150 6200 5250
Entry Wire Line
	6100 5250 6200 5350
Entry Wire Line
	6100 5350 6200 5450
Entry Wire Line
	6100 5450 6200 5550
Text Label 6250 4950 0    60   ~ 0
D3
Text Label 6250 5050 0    60   ~ 0
D5
Text Label 6250 5150 0    60   ~ 0
D7
Text Label 6250 5250 0    60   ~ 0
D6
Text Label 6250 5350 0    60   ~ 0
D4
Text Label 6250 5450 0    60   ~ 0
D2
Text Label 6250 5550 0    60   ~ 0
D0
Entry Wire Line
	8900 1100 9000 1200
Entry Wire Line
	8900 1200 9000 1300
Entry Wire Line
	8900 1300 9000 1400
Entry Wire Line
	8900 1400 9000 1500
Entry Wire Line
	8900 1500 9000 1600
Entry Wire Line
	8900 1600 9000 1700
Entry Wire Line
	8900 1700 9000 1800
Entry Wire Line
	8900 1800 9000 1900
Text Label 8500 1100 0    60   ~ 0
In0D0
Text Label 3850 1000 0    60   ~ 0
r1
Text Label 4050 1000 0    60   ~ 0
r0
Text Label 4750 1000 0    60   ~ 0
w1
Text Label 4950 1000 0    60   ~ 0
w0
Entry Wire Line
	10700 2050 10800 2150
Text Label 10300 2050 0    60   ~ 0
In0D0
$Comp
L GND #PWR05
U 1 1 58E0F5D4
P 10250 1250
F 0 "#PWR05" H 10250 1000 50  0001 C CNN
F 1 "GND" H 10250 1100 50  0000 C CNN
F 2 "" H 10250 1250 50  0000 C CNN
F 3 "" H 10250 1250 50  0000 C CNN
	1    10250 1250
	-1   0    0    1   
$EndComp
Text Label 8500 1200 0    60   ~ 0
In0D1
Text Label 8500 1300 0    60   ~ 0
In0D2
Text Label 8500 1400 0    60   ~ 0
In0D3
Text Label 8500 1500 0    60   ~ 0
In0D4
Text Label 8500 1600 0    60   ~ 0
In0D5
Text Label 8500 1700 0    60   ~ 0
In0D6
Text Label 8500 1800 0    60   ~ 0
In0D7
Entry Wire Line
	8900 2350 9000 2450
Entry Wire Line
	8900 2450 9000 2550
Entry Wire Line
	8900 2550 9000 2650
Entry Wire Line
	8900 2650 9000 2750
Entry Wire Line
	8900 2750 9000 2850
Entry Wire Line
	8900 2850 9000 2950
Entry Wire Line
	8900 2950 9000 3050
Entry Wire Line
	8900 3050 9000 3150
Text Label 8500 2350 0    60   ~ 0
In1D0
Text Label 8500 2450 0    60   ~ 0
In1D1
Text Label 8500 2550 0    60   ~ 0
In1D2
Text Label 8500 2650 0    60   ~ 0
In1D3
Text Label 8500 2750 0    60   ~ 0
In1D4
Text Label 8500 2850 0    60   ~ 0
In1D5
Text Label 8500 2950 0    60   ~ 0
In1D6
Text Label 8500 3050 0    60   ~ 0
In1D7
Entry Wire Line
	8900 3600 9000 3700
Entry Wire Line
	8900 3700 9000 3800
Entry Wire Line
	8900 3800 9000 3900
Entry Wire Line
	8900 3900 9000 4000
Entry Wire Line
	8900 4000 9000 4100
Entry Wire Line
	8900 4100 9000 4200
Entry Wire Line
	8900 4200 9000 4300
Entry Wire Line
	8900 4300 9000 4400
Text Label 8500 3600 0    60   ~ 0
Out1D1
Text Label 8500 3700 0    60   ~ 0
Out1D3
Text Label 8500 3800 0    60   ~ 0
Out1D5
Text Label 8500 3900 0    60   ~ 0
Out1D7
Text Label 8500 4000 0    60   ~ 0
Out1D6
Text Label 8500 4100 0    60   ~ 0
Out1D4
Text Label 8500 4200 0    60   ~ 0
Out1D2
Text Label 8500 4300 0    60   ~ 0
Out1D0
Entry Wire Line
	8900 4850 9000 4950
Entry Wire Line
	8900 4950 9000 5050
Entry Wire Line
	8900 5050 9000 5150
Entry Wire Line
	8900 5150 9000 5250
Entry Wire Line
	8900 5250 9000 5350
Entry Wire Line
	8900 5350 9000 5450
Entry Wire Line
	8900 5450 9000 5550
Entry Wire Line
	8900 5550 9000 5650
Text Label 8500 4850 0    60   ~ 0
Out0D1
Text Label 8500 4950 0    60   ~ 0
Out0D3
Text Label 8500 5050 0    60   ~ 0
Out0D5
Text Label 8500 5150 0    60   ~ 0
Out0D7
Text Label 8500 5250 0    60   ~ 0
Out0D6
Text Label 8500 5350 0    60   ~ 0
Out0D4
Text Label 8500 5450 0    60   ~ 0
Out0D2
Text Label 8500 5550 0    60   ~ 0
Out0D0
Entry Wire Line
	8900 4700 9000 4800
Text Label 8650 4700 0    60   ~ 0
/e1
Entry Wire Line
	8900 6000 9000 6100
Text Label 8650 6000 0    60   ~ 0
/e0
Entry Wire Line
	9000 3350 9100 3450
Text Label 9350 3450 0    60   ~ 0
/e1
Entry Wire Line
	10700 3450 10800 3550
Text Label 10300 3450 0    60   ~ 0
/e0
Entry Wire Line
	9000 1650 9100 1750
Entry Wire Line
	9000 1750 9100 1850
Entry Wire Line
	9000 1850 9100 1950
Entry Wire Line
	9000 1950 9100 2050
Entry Wire Line
	9000 2050 9100 2150
Entry Wire Line
	9000 2150 9100 2250
Entry Wire Line
	9000 2250 9100 2350
Entry Wire Line
	9000 2350 9100 2450
Text Label 9200 1750 0    60   ~ 0
In0D7
Text Label 9200 1850 0    60   ~ 0
In0D5
Text Label 9200 1950 0    60   ~ 0
In0D3
Text Label 9200 2050 0    60   ~ 0
In0D1
Text Label 9200 2150 0    60   ~ 0
In1D7
Text Label 9200 2250 0    60   ~ 0
In1D5
Text Label 9200 2350 0    60   ~ 0
In1D3
Text Label 9200 2450 0    60   ~ 0
In1D1
Entry Wire Line
	10700 1750 10800 1850
Entry Wire Line
	10700 1850 10800 1950
Entry Wire Line
	10700 1950 10800 2050
Entry Wire Line
	10700 2150 10800 2250
Entry Wire Line
	10700 2250 10800 2350
Entry Wire Line
	10700 2350 10800 2450
Entry Wire Line
	10700 2450 10800 2550
Text Label 10300 1750 0    60   ~ 0
In0D6
Text Label 10300 1850 0    60   ~ 0
In0D4
Text Label 10300 1950 0    60   ~ 0
In0D2
Text Label 10300 2150 0    60   ~ 0
In1D6
Text Label 10300 2250 0    60   ~ 0
In1D4
Text Label 10300 2350 0    60   ~ 0
In1D2
Text Label 10300 2450 0    60   ~ 0
In1D0
Entry Wire Line
	9000 2550 9100 2650
Entry Wire Line
	9000 2650 9100 2750
Entry Wire Line
	9000 2750 9100 2850
Entry Wire Line
	9000 2850 9100 2950
Entry Wire Line
	9000 2950 9100 3050
Entry Wire Line
	9000 3050 9100 3150
Entry Wire Line
	9000 3150 9100 3250
Entry Wire Line
	9000 3250 9100 3350
Entry Wire Line
	10700 2650 10800 2750
Entry Wire Line
	10700 2750 10800 2850
Entry Wire Line
	10700 2850 10800 2950
Entry Wire Line
	10700 2950 10800 3050
Entry Wire Line
	10700 3050 10800 3150
Entry Wire Line
	10700 3150 10800 3250
Entry Wire Line
	10700 3250 10800 3350
Entry Wire Line
	10700 3350 10800 3450
Text Label 9200 2650 0    60   ~ 0
Out1D6
Text Label 9200 2750 0    60   ~ 0
Out1D2
Text Label 9200 2850 0    60   ~ 0
Out1D1
Text Label 9200 2950 0    60   ~ 0
Out1D5
Text Label 9200 3050 0    60   ~ 0
Out0D6
Text Label 9200 3150 0    60   ~ 0
Out0D2
Text Label 9200 3250 0    60   ~ 0
Out0D1
Text Label 9200 3350 0    60   ~ 0
Out0D5
Text Label 10300 2650 0    60   ~ 0
Out1D4
Text Label 10300 2750 0    60   ~ 0
Out1D0
Text Label 10300 2850 0    60   ~ 0
Out1D3
Text Label 10300 2950 0    60   ~ 0
Out1D7
Text Label 10300 3050 0    60   ~ 0
Out0D4
Text Label 10300 3150 0    60   ~ 0
Out0D0
Text Label 10300 3250 0    60   ~ 0
Out0D3
Text Label 10300 3350 0    60   ~ 0
Out0D7
Text Notes 9200 5600 0    60   ~ 0
Achtung! \nBei den 74LS374 entsprechen die \nPin-Nummern nicht den Datenleitungen!\n\nD0 -> 18  (7) 19 -> D0\nD1 -> 3   (0)  2  -> D1\nD2 -> 17 (6)  16 -> D2\nD3 -> 4   (1)  5  -> D3\nD4 -> 14 (5)  15 -> D4\nD5 -> 7  (2)  6  -> D5\nD6 -> 13 (4)  12 -> D6\nD7 -> 8  (3)  9   -> D7\n\nDas ist in den Schaltplänen in\nden Büchern und Baumappen\nanders beschrieben!
Text Label 6250 3600 0    60   ~ 0
D1
Text Label 6250 3700 0    60   ~ 0
D3
Text Label 6250 3800 0    60   ~ 0
D5
Text Label 6250 3900 0    60   ~ 0
D7
Text Label 6250 4000 0    60   ~ 0
D6
Text Label 6250 4100 0    60   ~ 0
D4
Text Label 6250 4200 0    60   ~ 0
D2
Text Label 6250 4300 0    60   ~ 0
D0
$Comp
L 74LS688 J7
U 1 1 58E8961C
P 3050 5100
F 0 "J7" H 3050 6050 50  0000 C CNN
F 1 "74LS688" H 3050 4150 50  0000 C CNN
F 2 "Housings_DIP:DIP-20_W7.62mm_LongPads" H 3050 5100 50  0001 C CNN
F 3 "" H 3050 5100 50  0000 C CNN
	1    3050 5100
	-1   0    0    1   
$EndComp
$Comp
L RR8 8x3,3k
U 1 1 58E8B154
P 4750 5750
F 0 "8x3,3k" V 4900 5850 50  0000 C CNN
F 1 "RR8" V 4780 5750 50  0000 C CNN
F 2 "Resistors_ThroughHole:Resistor_Array_SIP8" H 4750 5750 50  0001 C CNN
F 3 "" H 4750 5750 50  0000 C CNN
	1    4750 5750
	0    1    1    0   
$EndComp
Text Label 5800 3650 0    60   ~ 0
/WR
$Comp
L GND #PWR06
U 1 1 58E8EA47
P 5100 2850
F 0 "#PWR06" H 5100 2600 50  0001 C CNN
F 1 "GND" H 5100 2700 50  0000 C CNN
F 2 "" H 5100 2850 50  0000 C CNN
F 3 "" H 5100 2850 50  0000 C CNN
	1    5100 2850
	0    -1   -1   0   
$EndComp
Entry Wire Line
	6000 3650 6100 3750
Entry Wire Line
	6000 3650 6100 3750
Entry Wire Line
	4100 5150 4200 5250
Text Label 3800 4250 0    60   ~ 0
/IORQ
Entry Wire Line
	4100 5250 4200 5350
Entry Wire Line
	4100 5350 4200 5450
Entry Wire Line
	4100 5450 4200 5550
Entry Wire Line
	4100 5550 4200 5650
Entry Wire Line
	4100 5650 4200 5750
Entry Wire Line
	4100 5750 4200 5850
Entry Wire Line
	4100 5850 4200 5950
$Comp
L GND #PWR07
U 1 1 58E91481
P 5900 5100
F 0 "#PWR07" H 5900 4850 50  0001 C CNN
F 1 "GND" H 5900 4950 50  0000 C CNN
F 2 "" H 5900 5100 50  0000 C CNN
F 3 "" H 5900 5100 50  0000 C CNN
	1    5900 5100
	1    0    0    -1  
$EndComp
$Comp
L VCC #PWR08
U 1 1 58E92110
P 5250 5350
F 0 "#PWR08" H 5250 5200 50  0001 C CNN
F 1 "VCC" H 5250 5500 50  0000 C CNN
F 2 "" H 5250 5350 50  0000 C CNN
F 3 "" H 5250 5350 50  0000 C CNN
	1    5250 5350
	0    1    1    0   
$EndComp
Text Label 3950 5250 0    60   ~ 0
A7
Text Label 3950 5350 0    60   ~ 0
A6
Text Label 3950 5450 0    60   ~ 0
A5
Text Label 3950 5550 0    60   ~ 0
A4
Text Label 3950 5650 0    60   ~ 0
A3
Text Label 3950 5750 0    60   ~ 0
A2
Text Label 3950 5850 0    60   ~ 0
A1
$Comp
L 74LS32 J8
U 1 1 58E9333F
P 2400 3200
F 0 "J8" H 2400 3250 50  0000 C CNN
F 1 "74LS32" H 2400 3150 50  0000 C CNN
F 2 "Housings_DIP:DIP-14_W7.62mm_LongPads" H 2400 3200 50  0001 C CNN
F 3 "" H 2400 3200 50  0000 C CNN
	1    2400 3200
	-1   0    0    1   
$EndComp
$Comp
L 74LS32 J8
U 2 1 58E93472
P 2400 3700
F 0 "J8" H 2400 3750 50  0000 C CNN
F 1 "74LS32" H 2400 3650 50  0000 C CNN
F 2 "Housings_DIP:DIP-14_W7.62mm_LongPads" H 2400 3700 50  0001 C CNN
F 3 "" H 2400 3700 50  0000 C CNN
	2    2400 3700
	-1   0    0    1   
$EndComp
$Comp
L VCC #PWR09
U 1 1 58E935AF
P 3100 1550
F 0 "#PWR09" H 3100 1400 50  0001 C CNN
F 1 "VCC" H 3100 1700 50  0000 C CNN
F 2 "" H 3100 1550 50  0000 C CNN
F 3 "" H 3100 1550 50  0000 C CNN
	1    3100 1550
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR010
U 1 1 58E93DA2
P 2050 1550
F 0 "#PWR010" H 2050 1300 50  0001 C CNN
F 1 "GND" H 2050 1400 50  0000 C CNN
F 2 "" H 2050 1550 50  0000 C CNN
F 3 "" H 2050 1550 50  0000 C CNN
	1    2050 1550
	-1   0    0    1   
$EndComp
$Comp
L C C4
U 1 1 58E93DCF
P 2550 2000
F 0 "C4" H 2575 2100 50  0000 L CNN
F 1 "100nF" V 2600 1700 50  0000 L CNN
F 2 "Capacitors_ThroughHole:C_Disc_D3_P2.5" H 2588 1850 50  0001 C CNN
F 3 "" H 2550 2000 50  0000 C CNN
	1    2550 2000
	0    1    1    0   
$EndComp
$Comp
L C C5
U 1 1 58E93E41
P 2550 2200
F 0 "C5" H 2575 2300 50  0000 L CNN
F 1 "100nF" V 2600 1900 50  0000 L CNN
F 2 "Capacitors_ThroughHole:C_Disc_D3_P2.5" H 2588 2050 50  0001 C CNN
F 3 "" H 2550 2200 50  0000 C CNN
	1    2550 2200
	0    1    1    0   
$EndComp
$Comp
L C C6
U 1 1 58E93E8F
P 2550 2400
F 0 "C6" H 2575 2500 50  0000 L CNN
F 1 "100nF" V 2600 2100 50  0000 L CNN
F 2 "Capacitors_ThroughHole:C_Disc_D3_P2.5" H 2588 2250 50  0001 C CNN
F 3 "" H 2550 2400 50  0000 C CNN
	1    2550 2400
	0    1    1    0   
$EndComp
$Comp
L C C7
U 1 1 58E93F5B
P 2550 2600
F 0 "C7" H 2575 2700 50  0000 L CNN
F 1 "100nF" V 2600 2300 50  0000 L CNN
F 2 "Capacitors_ThroughHole:C_Disc_D3_P2.5" H 2588 2450 50  0001 C CNN
F 3 "" H 2550 2600 50  0000 C CNN
	1    2550 2600
	0    1    1    0   
$EndComp
$Comp
L C C8
U 1 1 58E93FAB
P 2550 2800
F 0 "C8" H 2575 2900 50  0000 L CNN
F 1 "100nF" V 2600 2500 50  0000 L CNN
F 2 "Capacitors_ThroughHole:C_Disc_D3_P2.5" H 2588 2650 50  0001 C CNN
F 3 "" H 2550 2800 50  0000 C CNN
	1    2550 2800
	0    1    1    0   
$EndComp
$Comp
L C C3
U 1 1 58E94006
P 2550 1800
F 0 "C3" H 2575 1900 50  0000 L CNN
F 1 "100nF" V 2600 1500 50  0000 L CNN
F 2 "Capacitors_ThroughHole:C_Disc_D3_P2.5" H 2588 1650 50  0001 C CNN
F 3 "" H 2550 1800 50  0000 C CNN
	1    2550 1800
	0    1    1    0   
$EndComp
$Comp
L C C2
U 1 1 58E94070
P 2550 1600
F 0 "C2" H 2575 1700 50  0000 L CNN
F 1 "100nF" V 2600 1300 50  0000 L CNN
F 2 "Capacitors_ThroughHole:C_Disc_D3_P2.5" H 2588 1450 50  0001 C CNN
F 3 "" H 2550 1600 50  0000 C CNN
	1    2550 1600
	0    1    1    0   
$EndComp
Entry Wire Line
	800  3100 900  3200
Entry Wire Line
	800  3200 900  3300
Text Label 1000 3200 0    60   ~ 0
A2
Text Label 1000 3300 0    60   ~ 0
A3
NoConn ~ 1800 3200
NoConn ~ 1800 3700
$Comp
L SW_DIP_x8 S1
U 1 1 58E9DF71
P 5550 4650
F 0 "S1" H 5550 4200 50  0000 C CNN
F 1 "SW_DIP_x8" H 5550 5100 50  0000 C CNN
F 2 "Housings_DIP:DIP-16_W7.62mm_LongPads" H 5500 4650 50  0001 C CNN
F 3 "" H 5500 4650 50  0000 C CNN
	1    5550 4650
	-1   0    0    1   
$EndComp
NoConn ~ 5250 4300
$Comp
L CONN_01X08 P1
U 1 1 58EA8845
P 4750 4100
F 0 "P1" H 4750 4550 50  0000 C CNN
F 1 "CONN_01X08" V 4850 3700 50  0000 C CNN
F 2 "Pin_Headers:Pin_Header_Straight_1x08" H 4750 4100 50  0001 C CNN
F 3 "" H 4750 4100 50  0000 C CNN
	1    4750 4100
	0    -1   -1   0   
$EndComp
Wire Bus Line
	800  1000 800  6150
Wire Wire Line
	1150 1400 900  1400
Wire Wire Line
	1150 1500 900  1500
Wire Wire Line
	1150 1600 900  1600
Wire Wire Line
	1150 1700 900  1700
Wire Wire Line
	1150 1800 900  1800
Wire Wire Line
	1150 1900 900  1900
Wire Wire Line
	1150 2000 900  2000
Wire Wire Line
	1150 2100 900  2100
Wire Wire Line
	1150 2200 900  2200
Wire Wire Line
	1150 2300 900  2300
Wire Wire Line
	1150 2400 900  2400
Wire Wire Line
	1150 2500 900  2500
Wire Wire Line
	1150 2600 900  2600
Wire Wire Line
	1150 2700 900  2700
Wire Wire Line
	1150 3700 900  3700
Wire Wire Line
	1150 3600 900  3600
Wire Wire Line
	1150 3500 900  3500
Wire Wire Line
	900  3400 1150 3400
Wire Wire Line
	1150 3100 900  3100
Wire Wire Line
	1150 3000 900  3000
Wire Wire Line
	1150 2800 900  2800
Wire Bus Line
	800  6150 10950 6150
Wire Wire Line
	900  5050 1600 5050
Connection ~ 1050 5050
Wire Wire Line
	1050 4950 1050 5050
Wire Wire Line
	900  5500 1600 5500
Wire Wire Line
	1050 5350 1050 5500
Connection ~ 1050 5500
Wire Wire Line
	1150 1100 1000 1100
Wire Wire Line
	1000 1200 1150 1200
Wire Wire Line
	1000 1300 1150 1300
Wire Wire Line
	1000 2900 1150 2900
Wire Wire Line
	900  3200 1150 3200
Wire Wire Line
	900  3300 1150 3300
Wire Wire Line
	1000 3800 1150 3800
Wire Wire Line
	1000 3900 1150 3900
Wire Wire Line
	1000 4000 1150 4000
Wire Wire Line
	1000 4100 1150 4100
Wire Wire Line
	1000 4200 1150 4200
Wire Wire Line
	1000 4300 1150 4300
Wire Wire Line
	1000 4400 1150 4400
Wire Wire Line
	1000 4500 1150 4500
Wire Wire Line
	1000 4600 1150 4600
Wire Bus Line
	6100 1000 6100 6150
Wire Bus Line
	6100 3300 6100 4100
Wire Bus Line
	6100 3500 6100 4000
Wire Wire Line
	4800 3200 6000 3200
Wire Wire Line
	1450 5100 1450 5050
Connection ~ 1450 5050
Wire Wire Line
	1450 5400 1450 5500
Connection ~ 1450 5500
Wire Wire Line
	3850 2950 6000 2950
Wire Wire Line
	4750 2750 4750 2950
Wire Wire Line
	3850 2750 3850 2950
Connection ~ 4750 2950
Wire Wire Line
	4050 1050 4050 700 
Wire Wire Line
	4050 700  6650 700 
Wire Wire Line
	6650 700  6650 2100
Wire Wire Line
	6650 2100 6950 2100
Wire Wire Line
	3850 1050 3850 750 
Wire Wire Line
	3850 750  6600 750 
Wire Wire Line
	6600 750  6600 3350
Wire Wire Line
	6600 3350 6950 3350
Wire Wire Line
	4950 1050 4950 850 
Wire Wire Line
	4950 850  6500 850 
Wire Wire Line
	6500 850  6500 5750
Wire Wire Line
	4750 800  4750 1050
Wire Wire Line
	4750 800  6550 800 
Wire Wire Line
	4550 1050 4550 950 
Wire Wire Line
	4350 1050 4350 950 
Wire Wire Line
	3650 1050 3650 950 
Wire Wire Line
	3450 1050 3450 950 
Wire Wire Line
	6200 1100 6950 1100
Wire Wire Line
	6950 1800 6200 1800
Wire Wire Line
	6200 1700 6950 1700
Wire Wire Line
	6950 1600 6200 1600
Wire Wire Line
	6200 1500 6950 1500
Wire Wire Line
	6950 1400 6200 1400
Wire Wire Line
	6200 1300 6950 1300
Wire Wire Line
	6950 1200 6200 1200
Wire Wire Line
	6950 2000 6200 2000
Wire Wire Line
	6200 2350 6950 2350
Wire Wire Line
	6950 3050 6200 3050
Wire Wire Line
	6200 2950 6950 2950
Wire Wire Line
	6950 2850 6200 2850
Wire Wire Line
	6200 2750 6950 2750
Wire Wire Line
	6950 2650 6200 2650
Wire Wire Line
	6200 2550 6950 2550
Wire Wire Line
	6950 2450 6200 2450
Wire Wire Line
	6950 3250 6200 3250
Wire Wire Line
	4900 2750 4900 2850
Wire Wire Line
	4000 2750 4000 2850
Wire Wire Line
	6200 3600 6950 3600
Wire Wire Line
	6950 4300 6200 4300
Wire Wire Line
	6200 4200 6950 4200
Wire Wire Line
	6950 4100 6200 4100
Wire Wire Line
	6200 4000 6950 4000
Wire Wire Line
	6950 3900 6200 3900
Wire Wire Line
	6200 3800 6950 3800
Wire Wire Line
	6950 3700 6200 3700
Wire Wire Line
	6200 4850 6950 4850
Wire Wire Line
	6950 5550 6200 5550
Wire Wire Line
	6200 5450 6950 5450
Wire Wire Line
	6950 5350 6200 5350
Wire Wire Line
	6200 5250 6950 5250
Wire Wire Line
	6950 5150 6200 5150
Wire Wire Line
	6200 5050 6950 5050
Wire Wire Line
	6950 4950 6200 4950
Wire Bus Line
	9000 1000 9000 6150
Wire Bus Line
	10800 3900 9000 3900
Wire Bus Line
	10800 2200 10800 3900
Wire Bus Line
	10800 1750 10800 2250
Wire Wire Line
	8350 1100 8900 1100
Wire Wire Line
	8350 1200 8900 1200
Wire Wire Line
	8350 1300 8900 1300
Wire Wire Line
	8350 1400 8900 1400
Wire Wire Line
	8350 1500 8900 1500
Wire Wire Line
	8350 1600 8900 1600
Wire Wire Line
	8350 1700 8900 1700
Wire Wire Line
	8350 1800 8900 1800
Wire Wire Line
	10150 2050 10700 2050
Wire Wire Line
	9650 1650 9550 1650
Wire Wire Line
	9550 1450 9550 3550
Wire Wire Line
	9550 1450 10250 1450
Wire Wire Line
	10250 1250 10250 3550
Wire Wire Line
	10250 1650 10150 1650
Connection ~ 10250 1450
Wire Bus Line
	9000 6150 9050 6150
Wire Wire Line
	8350 2350 8900 2350
Wire Wire Line
	8350 2450 8900 2450
Wire Wire Line
	8350 2550 8900 2550
Wire Wire Line
	8350 2650 8900 2650
Wire Wire Line
	8350 2750 8900 2750
Wire Wire Line
	8350 2850 8900 2850
Wire Wire Line
	8350 2950 8900 2950
Wire Wire Line
	8350 3050 8900 3050
Wire Wire Line
	8350 3600 8900 3600
Wire Wire Line
	8350 3700 8900 3700
Wire Wire Line
	8350 3800 8900 3800
Wire Wire Line
	8350 3900 8900 3900
Wire Wire Line
	8350 4000 8900 4000
Wire Wire Line
	8350 4100 8900 4100
Wire Wire Line
	8350 4200 8900 4200
Wire Wire Line
	8350 4300 8900 4300
Wire Wire Line
	8350 4850 8900 4850
Wire Wire Line
	8350 4950 8900 4950
Wire Wire Line
	8350 5050 8900 5050
Wire Wire Line
	8350 5150 8900 5150
Wire Wire Line
	8350 5250 8900 5250
Wire Wire Line
	8350 5350 8900 5350
Wire Wire Line
	8350 5450 8900 5450
Wire Wire Line
	8350 5550 8900 5550
Wire Wire Line
	6950 4600 6900 4600
Wire Wire Line
	6900 4600 6900 4700
Wire Wire Line
	6900 4700 8900 4700
Wire Wire Line
	6950 5850 6900 5850
Wire Wire Line
	6900 5850 6900 6000
Wire Wire Line
	6900 6000 8900 6000
Wire Wire Line
	10250 2550 10150 2550
Connection ~ 10250 1650
Wire Wire Line
	10250 3550 10150 3550
Connection ~ 10250 2550
Connection ~ 9550 1650
Wire Wire Line
	9550 2550 9650 2550
Wire Wire Line
	9550 3550 9650 3550
Connection ~ 9550 2550
Wire Wire Line
	9650 3450 9100 3450
Wire Wire Line
	10150 3450 10700 3450
Wire Wire Line
	9100 1750 9650 1750
Wire Wire Line
	9100 1850 9650 1850
Wire Wire Line
	9100 1950 9650 1950
Wire Wire Line
	9100 2050 9650 2050
Wire Wire Line
	9100 2150 9650 2150
Wire Wire Line
	9100 2250 9650 2250
Wire Wire Line
	9100 2350 9650 2350
Wire Wire Line
	9100 2450 9650 2450
Wire Wire Line
	10150 1750 10700 1750
Wire Wire Line
	10150 1850 10700 1850
Wire Wire Line
	10150 1950 10700 1950
Wire Wire Line
	10150 2150 10700 2150
Wire Wire Line
	10150 2250 10700 2250
Wire Wire Line
	10150 2350 10700 2350
Wire Wire Line
	10150 2450 10700 2450
Wire Wire Line
	9100 2650 9650 2650
Wire Wire Line
	9100 2750 9650 2750
Wire Wire Line
	9100 2850 9650 2850
Wire Wire Line
	9100 2950 9650 2950
Wire Wire Line
	9100 3050 9650 3050
Wire Wire Line
	9100 3150 9650 3150
Wire Wire Line
	9100 3250 9650 3250
Wire Wire Line
	9100 3350 9650 3350
Wire Wire Line
	10150 2650 10700 2650
Wire Wire Line
	10150 2750 10700 2750
Wire Wire Line
	10150 2850 10700 2850
Wire Wire Line
	10150 2950 10700 2950
Wire Wire Line
	10150 3050 10700 3050
Wire Wire Line
	10150 3150 10700 3150
Wire Wire Line
	10150 3250 10700 3250
Wire Wire Line
	10150 3350 10700 3350
Wire Wire Line
	6550 800  6550 4500
Wire Wire Line
	6550 4500 6950 4500
Wire Wire Line
	6500 5750 6950 5750
Wire Wire Line
	4800 3650 6000 3650
Wire Wire Line
	4400 2750 4400 3050
Wire Wire Line
	4400 3050 3400 3050
Wire Wire Line
	3400 3050 3400 3750
Wire Wire Line
	3400 3750 3600 3750
Wire Wire Line
	4000 2850 5100 2850
Connection ~ 4900 2850
Wire Wire Line
	3750 5950 3850 5950
Wire Wire Line
	3850 5950 3850 5100
Wire Wire Line
	3750 5100 4400 5100
Wire Wire Line
	4400 5100 4400 5400
Connection ~ 3850 5100
Wire Wire Line
	3500 2750 3500 3300
Wire Wire Line
	3500 3300 3600 3300
Wire Wire Line
	2350 5950 2300 5950
Wire Wire Line
	2300 5950 2300 4000
Wire Wire Line
	2300 4000 4850 4000
Wire Wire Line
	4850 4000 4850 3400
Wire Wire Line
	4850 3850 4800 3850
Wire Wire Line
	4850 3400 4800 3400
Connection ~ 4850 3850
Wire Bus Line
	4200 5250 4200 6150
Wire Wire Line
	3750 4250 4100 4250
Wire Wire Line
	4100 4250 4100 5150
Wire Wire Line
	3750 5000 5250 5000
Wire Wire Line
	4500 5000 4500 5400
Wire Wire Line
	3750 4900 5250 4900
Wire Wire Line
	3750 4800 5250 4800
Wire Wire Line
	3750 4700 5250 4700
Wire Wire Line
	3750 4600 5250 4600
Wire Wire Line
	3750 4500 5250 4500
Wire Wire Line
	3750 4400 5250 4400
Wire Wire Line
	4600 4900 4600 5400
Connection ~ 4600 4900
Wire Wire Line
	4700 5400 4700 4800
Connection ~ 4700 4800
Wire Wire Line
	4800 5400 4800 4700
Connection ~ 4800 4700
Wire Wire Line
	4900 5400 4900 4600
Connection ~ 4900 4600
Wire Wire Line
	5000 5400 5000 4500
Connection ~ 5000 4500
Wire Wire Line
	5100 5400 5100 4400
Connection ~ 5100 4400
Wire Wire Line
	5200 5400 5200 5350
Wire Wire Line
	5200 5350 5250 5350
Wire Wire Line
	3750 5850 4100 5850
Wire Wire Line
	3750 5750 4100 5750
Wire Wire Line
	3750 5650 4100 5650
Wire Wire Line
	3750 5550 4100 5550
Wire Wire Line
	3750 5450 4100 5450
Wire Wire Line
	3750 5350 4100 5350
Wire Wire Line
	3750 5250 4100 5250
Connection ~ 4500 5000
Wire Wire Line
	3100 3100 3000 3100
Wire Wire Line
	3100 1550 3100 3800
Wire Wire Line
	3100 3300 3000 3300
Connection ~ 3100 3100
Wire Wire Line
	3100 3600 3000 3600
Connection ~ 3100 3300
Wire Wire Line
	3100 3800 3000 3800
Connection ~ 3100 3600
Wire Wire Line
	2050 1550 2050 2800
Wire Wire Line
	2050 1600 2400 1600
Wire Wire Line
	2050 1800 2400 1800
Connection ~ 2050 1600
Wire Wire Line
	2050 2000 2400 2000
Connection ~ 2050 1800
Wire Wire Line
	2050 2200 2400 2200
Connection ~ 2050 2000
Wire Wire Line
	2050 2400 2400 2400
Connection ~ 2050 2200
Wire Wire Line
	2050 2600 2400 2600
Connection ~ 2050 2400
Wire Wire Line
	2050 2800 2400 2800
Connection ~ 2050 2600
Wire Wire Line
	2700 1600 3100 1600
Connection ~ 3100 1600
Wire Wire Line
	2700 1800 3100 1800
Connection ~ 3100 1800
Wire Wire Line
	2700 2000 3100 2000
Connection ~ 3100 2000
Wire Wire Line
	2700 2200 3100 2200
Connection ~ 3100 2200
Wire Wire Line
	2700 2400 3100 2400
Connection ~ 3100 2400
Wire Wire Line
	2700 2600 3100 2600
Connection ~ 3100 2600
Wire Wire Line
	2700 2800 3100 2800
Connection ~ 3100 2800
Wire Wire Line
	5900 5000 5850 5000
Wire Wire Line
	5900 4300 5900 5100
Wire Wire Line
	5850 4900 5900 4900
Connection ~ 5900 5000
Wire Wire Line
	5850 4800 5900 4800
Connection ~ 5900 4900
Wire Wire Line
	5850 4700 5900 4700
Connection ~ 5900 4800
Wire Wire Line
	5850 4600 5900 4600
Connection ~ 5900 4700
Wire Wire Line
	5850 4500 5900 4500
Connection ~ 5900 4600
Wire Wire Line
	5850 4400 5900 4400
Connection ~ 5900 4500
Wire Wire Line
	5850 4300 5900 4300
Connection ~ 5900 4400
Wire Wire Line
	4400 4300 4400 5000
Connection ~ 4400 5000
Wire Wire Line
	4500 4300 4500 4900
Connection ~ 4500 4900
Wire Wire Line
	4600 4300 4600 4800
Connection ~ 4600 4800
Wire Wire Line
	4700 4300 4700 4700
Connection ~ 4700 4700
Wire Wire Line
	4800 4300 4800 4600
Connection ~ 4800 4600
Wire Wire Line
	4900 4300 4900 4500
Connection ~ 4900 4500
Wire Wire Line
	5000 4300 5000 4400
Connection ~ 5000 4400
NoConn ~ 5100 4300
Text Notes 950  7200 0    60   ~ 0
Änderungen zum Original:\n- Adressdekodierung mit 74LS688, damit werden nur noch 2 statt 16 Adressen belegt\n- Abblock-Kondensatoren\n- Offene Eingänge auf H-Pegel (außer bei den Ports) \n- Im Layout DB25-Stecker und 5V an der Pfostenleiste\n\nAchtung! Fehler im Original-Schaltplan:\n- w0 geht an J5\n- w1 geht an J4
$EndSCHEMATC
