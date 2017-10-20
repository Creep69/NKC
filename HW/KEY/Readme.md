NKC KEYr4 v1.1 Neuauflage 27.6.2017

Layout aus dem Buch �Rechner Modular� von Rolf Dieter Klein neu erfa�t mit Sprint Layout 6 von Rene Vetter. Verbesserungen und Fehlerbereinigungen mit Hilfe aus dem NKC Forum http://schuetz.thtec.org/forumdrc/ und Deff aus dem Robotrontechnikforum.

�nderungen im Vergleich zum Original:
- St�tzkondensatoren an nahezu s�mtlichen ICs.
- Freie Eing�nge auf +5V gelegt, um Einsatz von HCT ICs zu erm�glichen.
- ATTINY und PS/2 Buchse zum Anschlu� einer gebr�uchlichen PC-Tastatur mit PS/2-Stecker. Plan und Software hierf�r stammen von der Seite von Hschuetz: http://schuetz.thtec.org/NKC/hardware/tast.html Beschreibung und HEX File f�r den ATTINY befinden sich in diesem Archiv.
- Reset-Pin f�r die erweiterte Funktion der Tastatur: Der Reset-Pin mu� zum Resetschalter der Z80CPU gef�hrt werden, nicht an den BUS!
- Ein Pin-Header zum Anschlu� einer externen PS/2 Buchse ist ebenfalls vorgesehen.
- Die Defaultpositionen f�r die Adressjumper sind markiert.
- Der �ready� Jumper neben den Adressjumpern mu� im Normalfall gesteckt sein.

WICHTIG: Im Layout der produzierten Version 1.0 sind die Pins 8-13 des IC5 (74LS00) fehlerhaft beschaltet. Die Ausg�nge Pin 8 und 11 liegen auf +5V! Bei Verwendung von 7400 oder 74LS00 m�ssen die Leiterz�ge zu Pin 8 und 11 getrennt werden oder einfach die beiden Pins nicht in die Fassung gesteckt werden. Bei Verwendung von 74HCT00 m�ssen au�erdem Pin 10 mit Pin 9 und Pin13 mit Pin 14 verbunden werden.

In der Version 1.1 ist das Layout korrigiert.


History:

V1.1: 27.6.2017 RV+Deff
Berichtigung der fehlerhaften Verbindung von IC5 Pin 8-13.
Verschieben des 10�F Kondensators, damit die Platine auch in einen Platinenhalter pa�t.

V1.0: 9.4.2017 RV+Deff
Erste Neuauflage