NKC GDP64 v1.1 Neuauflage 4.4.2017

Layout aus dem Buch „Rechner Modular“ von Rolf Dieter Klein neu erfaßt mit Sprint Layout 6 von Rene Vetter. Verbesserungen und Fehlerbereinigungen mit Hilfe aus dem NKC Forum http://schuetz.thtec.org/forumdrc/ und Deff aus dem Robotrontechnikforum.

Änderungen im Vergleich zum Original:
- Stützkondensatoren an nahezu sämtlichen ICs. Für die DRAMs sollten Sockel mit integriertem Stützkondensator verwendet oder die 100nF Kondensatoren direkt auf der Rückseite aufgelötet werden.
- Freie Eingänge auf +5V gelegt, um Einsatz von HCT ICs zu ermöglichen.
- Ersatz des diskreten durch einen integrierten Quarzoszillator.
- Dadurch Einsparen des 7404. Das einzig nötige Gatter wurde in den 7405 verlegt (Pin 5+6) und dessen Ausgang mit einem 1k2 Pullup-Widerstand versehen.
- Der freigewordene Platz wurde genutzt, um eine Chinchbuchse für das BAS Signal unterzubringen.

Hinweis: Anstelle des schwer beschaffbaren 25LS2538 kann auch ein leichter verfügbarer 74F538 verwendet werden.

Die Version v1.2 enthält noch den Scroll-Fix aus der Zeitschrift LOOP und paßt genau ins billige 10x10cm Format.


History:

V1.2: 3.7.2017 RV+Deff
Scroll-Fix aus LOOP 17
10x10cm Format

V1.1: 4.4.2017 RV
Behebung von Layoutfehlern aus v1.0
IC 7404 entfallen und durch Gatter des 7405 ersetzt.

V1.0: 18.2.2017 RV
Erste Neuauflage