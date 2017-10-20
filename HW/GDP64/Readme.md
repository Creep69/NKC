NKC GDP64 v1.1 Neuauflage 4.4.2017

Layout aus dem Buch �Rechner Modular� von Rolf Dieter Klein neu erfa�t mit Sprint Layout 6 von Rene Vetter. Verbesserungen und Fehlerbereinigungen mit Hilfe aus dem NKC Forum http://schuetz.thtec.org/forumdrc/ und Deff aus dem Robotrontechnikforum.

�nderungen im Vergleich zum Original:
- St�tzkondensatoren an nahezu s�mtlichen ICs. F�r die DRAMs sollten Sockel mit integriertem St�tzkondensator verwendet oder die 100nF Kondensatoren direkt auf der R�ckseite aufgel�tet werden.
- Freie Eing�nge auf +5V gelegt, um Einsatz von HCT ICs zu erm�glichen.
- Ersatz des diskreten durch einen integrierten Quarzoszillator.
- Dadurch Einsparen des 7404. Das einzig n�tige Gatter wurde in den 7405 verlegt (Pin 5+6) und dessen Ausgang mit einem 1k2 Pullup-Widerstand versehen.
- Der freigewordene Platz wurde genutzt, um eine Chinchbuchse f�r das BAS Signal unterzubringen.

Hinweis: Anstelle des schwer beschaffbaren 25LS2538 kann auch ein leichter verf�gbarer 74F538 verwendet werden.

Die Version v1.2 enth�lt noch den Scroll-Fix aus der Zeitschrift LOOP und pa�t genau ins billige 10x10cm Format.


History:

V1.2: 3.7.2017 RV+Deff
Scroll-Fix aus LOOP 17
10x10cm Format

V1.1: 4.4.2017 RV
Behebung von Layoutfehlern aus v1.0
IC 7404 entfallen und durch Gatter des 7405 ersetzt.

V1.0: 18.2.2017 RV
Erste Neuauflage