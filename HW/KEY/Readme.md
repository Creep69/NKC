NKC KEYr4 v1.1 Neuauflage 27.6.2017

Layout aus dem Buch „Rechner Modular“ von Rolf Dieter Klein neu erfaßt mit Sprint Layout 6 von Rene Vetter. Verbesserungen und Fehlerbereinigungen mit Hilfe aus dem NKC Forum http://schuetz.thtec.org/forumdrc/ und Deff aus dem Robotrontechnikforum.

Änderungen im Vergleich zum Original:
- Stützkondensatoren an nahezu sämtlichen ICs.
- Freie Eingänge auf +5V gelegt, um Einsatz von HCT ICs zu ermöglichen.
- ATTINY und PS/2 Buchse zum Anschluß einer gebräuchlichen PC-Tastatur mit PS/2-Stecker. Plan und Software hierfür stammen von der Seite von Hschuetz: http://schuetz.thtec.org/NKC/hardware/tast.html Beschreibung und HEX File für den ATTINY befinden sich in diesem Archiv.
- Reset-Pin für die erweiterte Funktion der Tastatur: Der Reset-Pin muß zum Resetschalter der Z80CPU geführt werden, nicht an den BUS!
- Ein Pin-Header zum Anschluß einer externen PS/2 Buchse ist ebenfalls vorgesehen.
- Die Defaultpositionen für die Adressjumper sind markiert.
- Der „ready“ Jumper neben den Adressjumpern muß im Normalfall gesteckt sein.

WICHTIG: Im Layout der produzierten Version 1.0 sind die Pins 8-13 des IC5 (74LS00) fehlerhaft beschaltet. Die Ausgänge Pin 8 und 11 liegen auf +5V! Bei Verwendung von 7400 oder 74LS00 müssen die Leiterzüge zu Pin 8 und 11 getrennt werden oder einfach die beiden Pins nicht in die Fassung gesteckt werden. Bei Verwendung von 74HCT00 müssen außerdem Pin 10 mit Pin 9 und Pin13 mit Pin 14 verbunden werden.

In der Version 1.1 ist das Layout korrigiert.


History:

V1.1: 27.6.2017 RV+Deff
Berichtigung der fehlerhaften Verbindung von IC5 Pin 8-13.
Verschieben des 10µF Kondensators, damit die Platine auch in einen Platinenhalter paßt.

V1.0: 9.4.2017 RV+Deff
Erste Neuauflage