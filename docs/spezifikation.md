# 36-Fragen-App – Spezifikation Version 1

24.10.2026 · Christoph

> Auszug aus dem Projektdokument, Stand 28.10.2026: alle User Stories (US-01 bis US-19) und die nicht-funktionalen Anforderungen. Nicht enthalten sind Konkurrenzanalyse, Risiken und Markenfragen. Maßgeblich ist das Dokument; Änderungen kommen per Pull Request hierher. Die Technik steht in [technisches-konzept.md](technisches-konzept.md).

> **Stand 28.10.2026:** Version 1 erscheint als Web-App (PWA) für Freunde, nicht in den Stores. Werbung (US-16), Kauf (US-17) und Datenschutz-Optionen (US-18) ruhen, ihr Code bleibt abgeschaltet erhalten. Was über Store-Einträge, Store-Prüfung, Altersfreigabe und Länder steht, gilt erst für einen späteren Store-Release. Die Technik beschreibt das Technische Konzept unter „Web-App (PWA)“.

## Ziel und Zielgruppe

Die App „Pas de deux“ führt zwei Menschen, die sich kennenlernen, Zug um Zug durch 36 Fragen nach der Idee von Arthur Aron. Version 1 erscheint als Web-App, die sich auf iPhone und Android-Smartphones wie eine App auf den Home-Bildschirm legen lässt, auf Deutsch, Englisch, Spanisch, Italienisch und Französisch.

- **Zielgruppe:** Menschen beim Kennenlernen, vom ersten Date bis zu den ersten Monaten. Langjährige Paare sind keine Zielgruppe.
- **Grundlage:** 36 eigene Fragen nach der Idee der Studie „The Experimental Generation of Interpersonal Closeness“ (Aron et al., 1997). Sie sind wie dort in drei Stufen zu je 12 Fragen geordnet, die immer persönlicher werden. Den Wortlaut der Studie übernimmt die App nicht.
- **Nutzung:** Beide sitzen zusammen und reichen ein Handy hin und her.
- **Finanzierung:** keine in Version 1. Werbung und eine werbefreie Version als Einmalkauf sind vorbereitet und ruhen bis zu einem Store-Release.

## Umfang von Version 1

Version 1 ist bewusst klein: 36 eigene Fragen nach dem Vorbild der Studie, ein Gerät, kein Konto, nach dem ersten Öffnen ohne Internet spielbar.

**Enthalten**

- Partie einstellen: Stufen und Zahl der Fragen
- Geführter Ablauf mit zwei Namen und Zugwechsel
- Gegenseitige Bewertung der Antworten
- Zufallsauswahl innerhalb jeder Stufe, leicht gewichtet nach früheren Bewertungen; Fragen der letzten Partie seltener
- Abschluss mit 4-Minuten-Blick und „Eure schönsten Momente“
- Fünf Sprachen, Fragen wahlweise in zwei Sprachen gleichzeitig
- Werbung und werbefreie Version als Einmalkauf (ruhen in der Web-App)

**Nicht enthalten**

- Spielen auf zwei Geräten oder aus der Ferne
- Fragen über die 36 hinaus, von Nutzern geschriebene Fragen, Fragenpakete
- Konto, Anmeldung, Abgleich zwischen Geräten
- Abo
- Angebote für langjährige Paare

## Begriffe

| Begriff | Bedeutung |
| --- | --- |
| Partie | Ein Durchgang vom Einstellen bis zum Abschluss. |
| Stufe | Eine der drei Gruppen zu je 12 Fragen, aufgebaut wie in der Studie. Stufe 1 ist leicht, Stufe 3 sehr persönlich. Ersetzt das Wort „Kategorie“. |
| Frage | Eine der 36 neu formulierten Fragen, mit fester Kennung wie `s1-q04` (Stufe 1, Frage 4), unabhängig von der Sprache. |
| Zug | Eine Frage in einer Partie: Beide antworten nacheinander und bewerten jeweils die Antwort des anderen. |
| Beginnende Person | Wer in einem Zug zuerst antwortet. Wechselt mit jedem Zug. |
| Bewertung | Wie sehr die Antwort des Gegenübers berührt hat, in drei Stufen. Freiwillig. |
| Gewicht | Zahl je Frage auf dem Gerät. Sie bestimmt, wie wahrscheinlich die Frage in späteren Partien gezogen wird. |

## Einrichtung

### US-01 Sprache

Als Nutzer möchte ich die App in meiner Sprache nutzen, damit ich die Fragen mühelos verstehe.

- Beim ersten Start übernimmt die App die Gerätesprache, wenn sie eine der fünf Sprachen ist. Sonst gilt Englisch.
- In den Einstellungen lässt sich die Sprache außerhalb einer laufenden Partie ändern.
- Der Wechsel wirkt sofort, ohne Neustart.
- Gewichte bleiben beim Wechsel erhalten.

### US-02 Einführung

Als neuer Nutzer möchte ich kurz erfahren, wie das Spiel funktioniert, damit wir gleich loslegen können.

- Beim ersten Start erscheint eine Einführung mit höchstens drei Seiten: Herkunft der Fragen, Ablauf eines Zugs, Dauer von etwa 45 Minuten für alle 36 Fragen.
- Die Einführung lässt sich überspringen und in den Einstellungen wieder aufrufen.
- Sie verspricht nicht, dass man sich verliebt. Die Wirkung der Studie ist umstritten.
- Die Einführung nennt die Quelle: „Nach einer Idee aus der Studie von Aron et al. (1997)“. Die vollständige Literaturangabe steht in den Einstellungen unter „Über die App“. Nichts erweckt den Eindruck, die Autoren unterstützten die App.

### US-03 Namen

Als Paar möchten wir unsere Vornamen eingeben, damit die App sagt, wer dran ist.

- Vor jeder Partie gibt es zwei Namensfelder mit je 1 bis 20 Zeichen.
- Bleibt ein Feld leer, gilt „Person A“ oder „Person B“.
- Die App merkt sich nur den ersten Namen, also den der Person, der das Handy gehört. Das zweite Feld ist bei jeder Partie leer, denn beim Daten wechselt das Gegenüber.
- Namen werden nur auf dem Gerät gespeichert.

## Partie einstellen

### US-04 Stufen wählen

Als Paar möchten wir wählen, welche Stufen vorkommen, damit die Fragen zu unserem Stand passen.

- Drei Stufen stehen zur Wahl, jede mit Name und einem Satz zur Tiefe, etwa „Stufe 1 – Leicht: zum Warmwerden“.
- Mindestens eine Stufe muss gewählt sein, sonst ist „Start“ deaktiviert.
- Beim ersten Start sind alle drei Stufen gewählt, wie im Original. Danach gilt die zuletzt gewählte Einstellung.
- Die Stufen kommen immer in der Reihenfolge 1, 2, 3, auch bei Lücken (etwa nur 1 und 3).

### US-05 Zahl der Fragen

Als Paar möchten wir die Zahl der Fragen festlegen, damit die Partie in unsere Zeit passt.

- Das Minimum ist eine Frage je gewählter Stufe, das Maximum 12 Fragen je gewählter Stufe.
- Voreingestellt sind alle Fragen der gewählten Stufen.
- Die App zeigt die geschätzte Dauer, gerechnet mit 75 Sekunden je Frage (45 Minuten für 36 Fragen).
- Ändert sich die Auswahl der Stufen, wird die Zahl auf das neue Maximum begrenzt.

### US-06 Verteilung auf die Stufen

Als Paar möchten wir, dass sich die Fragen auf alle gewählten Stufen verteilen, damit die Steigerung erhalten bleibt.

- Die Zahl wird möglichst gleich auf die gewählten Stufen verteilt. Ein Rest geht zuerst an die niedrigere Stufe: 10 Fragen auf drei Stufen ergeben 4, 3 und 3.
- Die Verteilung steht vor dem Start sichtbar da, etwa „4 · 3 · 3“.

## Spielablauf

In jedem Zug antworten beide, und das Handy wechselt genau einmal die Hand.

*[Grafik im Projektdokument: Ablauf einer Partie · ein Zug, Stufenwechsel, Abschluss]*

Wer zuletzt bewertet hat, hält das Handy noch, wenn im nächsten Zug die andere Person beginnt. Bewerten ist in beiden Schritten freiwillig.

### US-07 Zugwechsel

Als Paar möchten wir, dass die App sagt, wer antwortet und wer das Handy hält, damit wir nicht durcheinanderkommen.

- Jeder Zug zeigt die Frage groß und darüber, wer antwortet und wer das Handy hält: „Lena antwortet zuerst. Max hält das Handy.“
- Nach der Bewertung durch Max zeigt die App: „Jetzt antwortet Max. Gib das Handy an Lena.“
- Die beginnende Person wechselt mit jedem Zug. Im ersten Zug der Partie bestimmt sie der Zufall.
- Wer zuletzt bewertet hat, hält das Handy auch zu Beginn des nächsten Zugs. So wechselt es einmal pro Zug die Hand.
- Der Bildschirm geht während einer Partie nicht aus. In der Web-App gilt das, solange sie im Vordergrund ist.
- Ein Fortschritt zeigt, die wievielte Frage läuft, etwa „7 von 12“.

### US-08 Übergang zwischen Stufen

Als Paar möchten wir merken, wenn die Fragen persönlicher werden, damit wir uns darauf einstellen können.

- Beginnt eine neue Stufe, erscheint ein Zwischenbildschirm mit ihrem Namen und einem Satz, etwa „Jetzt wird es persönlicher“.
- Weiter geht es mit einem Tipp.
- In Partien mit nur einer Stufe gibt es keinen Zwischenbildschirm.

### US-09 Überspringen

Als Paar möchten wir eine Frage überspringen können, damit niemand etwas beantworten muss, das sich falsch anfühlt.

- „Überspringen“ ist in jedem Zug sichtbar, solange noch niemand bewertet hat.
- Die App zieht dann eine Ersatzfrage aus derselben Stufe, solange dort ungespielte Fragen übrig sind. Sonst sinkt die Zahl der Fragen um eins.
- Eine übersprungene Frage kommt in dieser Partie nicht wieder.
- Überspringen ändert keine Gewichte.

### US-10 Zurück

Als Paar möchten wir einen Schritt zurückgehen können, damit ein versehentlicher Tipp nichts kaputt macht.

- „Zurück“ führt zum vorherigen Schritt, auch innerhalb eines Zugs (von der Bewertung zur Frage).
- Eine abgegebene Bewertung lässt sich dabei ändern.
- Zurück geht höchstens bis zur ersten Frage der Partie.

### US-11 Unterbrechen und beenden

Als Paar möchten wir eine Partie unterbrechen oder vorzeitig beenden können, damit wir frei bleiben.

- Wer die App verlässt, findet die Partie beim nächsten Öffnen an derselben Stelle, solange keine neue Partie gestartet wurde.
- „Partie beenden“ fragt nach einer Bestätigung und führt zum Abschluss mit den bis dahin gespielten Fragen.
- Bewertungen aus beendeten Partien zählen für die Gewichte.

## Bewertung

Jede Person bewertet die Antwort des Gegenübers mit einer von drei freundlichen Stufen. Keine Stufe heißt „schlecht“, denn beim ersten Date sieht das Gegenüber zu.

| Bewertung (DE) | Wert |
| --- | --- |
| Hat mich berührt | 2 |
| Interessant | 1 |
| Okay | 0 |
| keine Bewertung | zählt nicht |

### US-12 Antwort bewerten

Als Spieler möchte ich die Antwort meines Gegenübers bewerten, damit wir am Ende sehen, welche Momente uns am meisten bedeutet haben.

- Nach jeder Antwort fragt die App die Person mit dem Handy: „Max, wie hat dich die Antwort von Lena berührt?“ Die Form „die Antwort von“ vermeidet den Genitiv bei Namen wie Jonas.
- Drei gleich große Knöpfe mit den Stufen aus der Tabelle.
- Die Bewertung ist freiwillig: „Weiter ohne Bewertung“ ist immer sichtbar.
- Die abgegebene Bewertung ist auf dem nächsten Bildschirm nicht mehr zu sehen. Das Gegenüber erfährt sie nur, wenn sie in den schönsten Momenten auftaucht (US-15).
- Je Zug gibt es bis zu zwei Bewertungen, eine pro Person.

## Auswahl der Fragen

Innerhalb jeder Stufe zieht die App zufällig, leicht gewichtet nach früheren Bewertungen. In einer Partie kommt keine Frage zweimal vor, und Fragen der letzten Partie kommen seltener.

### US-13 Gewichteter Zufall

Als Nutzer möchte ich, dass spätere Partien etwas öfter Fragen enthalten, die gut ankamen, damit die Gespräche besser werden.

- Jede Frage startet mit dem Gewicht 1,0.
- Für jede gewählte Stufe zieht die App so viele Fragen, wie US-06 vorgibt, ohne Zurücklegen. Die Wahrscheinlichkeit einer Frage ist ihr Gewicht w mal einem Faktor f, geteilt durch dieselbe Summe über alle noch nicht gezogenen Fragen dieser Stufe:

```math
P(i) = \frac{w_i \cdot f_i}{\sum_{j \in \text{offen}} w_j \cdot f_j}
```

- Der Faktor f ist 0,5 für jede Frage, die in der letzten Partie gezeigt wurde, auch wenn sie übersprungen oder die Partie abgebrochen wurde. Für alle anderen Fragen ist f gleich 1. Das gespeicherte Gewicht w ändert sich dadurch nicht.
- Die Reihenfolge des Ziehens ist die Reihenfolge in der Partie. Die Stufen bleiben in der Reihenfolge 1, 2, 3.
- Nach jedem Zug mit mindestens einer Bewertung bildet die App den Durchschnitt der Werte:
  - ab 1,5: Gewicht mal 1,2
  - beide haben „Okay“ gewählt: Gewicht mal 0,7
  - sonst: keine Änderung
- Ein Gewicht bleibt zwischen 0,3 und 3,0. Keine Frage fällt also ganz heraus.
- Die Gewichte gelten für das Gerät, nicht für ein Paar, und enthalten keine Namen.
- In den Einstellungen setzt „Gewichte zurücksetzen“ alle Fragen auf 1,0.

Die Gewichte wirken nur, wenn weniger Fragen gespielt werden, als eine Stufe hat. Bei allen 12 Fragen einer Stufe ändern sie nur die Reihenfolge.

## Abschluss

### US-14 4-Minuten-Blick

Als Paar möchten wir am Ende den Blick aus dem Original machen, damit das Experiment vollständig ist.

- Nach der letzten Frage bietet die App den 4-Minuten-Blick mit einem Satz Erklärung an. „Überspringen“ ist möglich.
- Der Timer läuft 4:00 Minuten und startet per Tipp.
- Während er läuft, ist der Bildschirm ruhig und dunkel und zeigt nur klein die Restzeit. Beide schauen sich an, nicht aufs Handy.
- Das Ende meldet ein sanfter Ton mit Vibration. Der Ton lässt sich in den Einstellungen abschalten. In der Web-App auf dem iPhone gibt es keine Vibration, nur den Ton.
- Abbrechen ist jederzeit möglich.

### US-15 Eure schönsten Momente

Als Paar möchten wir am Ende sehen, welche Antworten uns berührt haben, damit wir mit einem guten Gefühl abschließen.

- Die App zeigt bis zu drei Fragen mit der höchsten Summe der Bewertungen. Jede davon hat mindestens einmal „Hat mich berührt“.
- Bei jeder Frage steht, wessen Antwort berührt hat: „Die Antwort von Max hat Lena berührt.“
- Niedrige Bewertungen und Einzelwerte erscheinen nie.
- Gibt es keine solche Frage, erscheint ein freundlicher Abschlusstext ohne Liste.
- Nach dem Verlassen ist die Zusammenfassung weg. Gespeichert bleiben nur die Gewichte, ohne Namen.
- Danach gibt es „Neue Partie“ und „Zum Start“.

## Mehrsprachigkeit

App, Fragen und Store-Einträge sind in allen fünf Sprachen vollständig. Keine Sprache startet halb fertig.

Die Fragen in allen fünf Sprachen stehen im Tab Fragen.

- Alle Texte liegen in Sprachdateien, nicht im Code.
- Bewertungen und Gewichte hängen an der Kennung der Frage, nicht an ihrem Text.
- Die Fragen werden auf Deutsch neu geschrieben: Thema und Stufe wie in der Studie, aber in eigenen Worten. Eine nur leicht umgestellte Fassung des Originals reicht nicht.
- Alle anderen Sprachen übersetzt eine KI aus dem Deutschen, dazu App-Texte und Store-Einträge. Jede Sprachfassung, besonders Englisch, wird gegen den Originalwortlaut geprüft: Keine Frage darf ihm wörtlich oder fast wörtlich gleichen. Nichts wird von Webseiten übernommen.
- Die Anrede ist informell: du, tu, tú, tu.
- Sätze mit Namen funktionieren in jeder Sprache ohne Beugung, etwa „die Antwort von Lena“.
- Das Layout verträgt Texte, die rund 30 % länger sind als im Englischen, ohne abzuschneiden.
- Store-Titel, Untertitel, Beschreibung und Screenshots gibt es je Sprache. Name und Untertitel haben in beiden Stores höchstens 30 Zeichen. Der Suchbegriff verteilt sich deshalb im App Store auf Name und Untertitel. Bei Google Play steht er vollständig in der Kurzbeschreibung (bis zu 80 Zeichen):

| Sprache | Name (beide Stores) | Untertitel (App Store) | Suchbegriff in der Kurzbeschreibung (Google Play) |
| --- | --- | --- | --- |
| Deutsch | Pas de deux: 36 Fragen | zum Verlieben, Zug um Zug | 36 Fragen zum Verlieben |
| Englisch | Pas de deux: 36 Questions | to fall in love, turn by turn | 36 Questions to Fall in Love |
| Spanisch | Pas de deux: 36 preguntas | para enamorarse, por turnos | 36 preguntas para enamorarse |
| Italienisch | Pas de deux: 36 domande | per innamorarsi, a turno | 36 domande per innamorarsi |
| Französisch | Pas de deux : 36 questions | pour tomber amoureux | 36 questions pour tomber amoureux |

### US-19 Fragen in zwei Sprachen

Als Paar mit verschiedenen Muttersprachen möchten wir jede Frage in zwei Sprachen sehen, damit beide sie gleich gut verstehen.

- Beim Einstellen der Partie gibt es „Zweite Sprache“: aus oder eine der vier anderen Sprachen. Voreingestellt ist „aus“, danach gilt die letzte Wahl.
- Höchstens zwei Sprachen gleichzeitig, damit auch lange Fragen auf einen Handybildschirm passen.
- Oben steht die Frage in der App-Sprache, darunter in der zweiten Sprache. Beide sind gleich groß, durch eine Linie getrennt und mit Kürzel gekennzeichnet (DE, ES).
- Passt der Text nicht auf den Bildschirm, lässt er sich scrollen. Nichts wird abgeschnitten oder verkleinert.
- Ebenfalls zweisprachig: Name und Satz beim Stufenübergang, die drei Bewertungsknöpfe und die Fragen in „Eure schönsten Momente“. Alle anderen Texte bleiben in der App-Sprache.
- Der Screenreader liest jeden Text in seiner eigenen Sprache vor.
- Wird die App-Sprache auf die zweite Sprache umgestellt, schaltet sich die zweite Sprache aus.

## Werbung und werbefreie Version

> **Ruht in der Web-App:** Werbung und Kauf sind abgeschaltet. US-16 bis US-18 gelten für einen späteren Store-Release.

Werbung erscheint nie während einer Partie und ist nie personalisiert. Die werbefreie Version ist ein Einmalkauf in derselben App, keine zweite App. So gibt es nur einen Store-Eintrag, und alle Bewertungen sammeln sich an einer Stelle.

### US-16 Werbung, die nicht stört

Als Paar möchten wir während der Partie keine Werbung sehen, damit der Moment nicht kaputtgeht.

- Werbung gibt es nur an zwei Stellen: als Banner auf dem Startbildschirm und als höchstens eine Vollbildanzeige pro Partie, nach „Neue Partie“ oder „Zum Start“ am Ende.
- Keine Werbung in Einführung, Partie, Stufenübergang, 4-Minuten-Blick und Zusammenfassung.
- Vollbildanzeigen nur als Bild, keine Videos.
- Ohne Internet erscheint keine Werbung. Das Spiel läuft trotzdem vollständig.
- Vor der ersten Werbung im EWR, im Vereinigten Königreich und in der Schweiz erscheint ein Einwilligungsdialog. Google verlangt dafür eine zertifizierte Einwilligungslösung (CMP), etwa die von Google selbst.
- Ohne Einwilligung läuft die App weiter. Google zeigt dann eingeschränkte Anzeigen ohne Cookies und Werbe-IDs.
- Nur nicht personalisierte Werbung: Jede Anzeigenanfrage setzt nonPersonalizedAds auf true. Unter iOS gibt es keine Tracking-Abfrage (ATT).

### US-17 Werbefreie Version kaufen

Als Nutzer möchte ich die Werbung mit einem Einmalkauf entfernen, damit ich die App ohne Unterbrechung nutze.

- Ein einmaliger In-App-Kauf „Werbefrei“, kein Abo. Der Preis ist 1,99 €. Für andere Länder gelten die Preise, die die Stores automatisch daraus ableiten.
- Der Kaufknopf steht in den Einstellungen und dezent auf dem Startbildschirm, nie in einer Partie.
- Nach dem Kauf verschwindet jede Werbung sofort, ohne Neustart. Der Einwilligungsdialog erscheint dann nicht mehr.
- „Käufe wiederherstellen“ steht in den Einstellungen. Apple verlangt das.
- Der Kaufstatus wird auf dem Gerät gespeichert. Die App bleibt so auch ohne Internet werbefrei.

### US-18 Datenschutz-Optionen

Als Nutzer möchte ich meine Einwilligung zur Werbung jederzeit ändern können, damit ich über meine Daten bestimme.

- In den Einstellungen steht „Datenschutz-Optionen“, wenn das Plugin meldet, dass sie nötig sind (PrivacyOptionsRequirementStatus, in Europa). Sonst ist der Eintrag ausgeblendet.
- Der Eintrag öffnet den Einwilligungsdialog erneut.
- Die neue Wahl gilt ab der nächsten Anzeige.
- Nach dem Kauf „Werbefrei“ entfällt der Eintrag.

## Nicht-funktionale Anforderungen

| Bereich | Anforderung |
| --- | --- |
| Plattformen | Web-App für aktuelle Browser auf dem iPhone (Safari) und auf Android-Smartphones (Chrome), auf dem Home-Bildschirm wie eine App. Tablets und Computer funktionieren, bekommen aber kein eigenes Layout. Für einen Store-Release: mindestens iOS 18 und Android 7.0 (API 24), Ziel-API 36, einmal im Jahr ein Pflicht-Update. |
| Technik | Flutter, eine Codebasis für Web, iOS und Android. Werbung und Einwilligung (google_mobile_ads) sowie der Kauf (in_app_purchase) sind eingebaut, aber abgeschaltet. Texte in ARB-Dateien je Sprache. |
| Offline | Nach dem ersten Öffnen funktioniert alles ohne Internet. Die Fragen sind in der App enthalten, nichts wird nachgeladen. Mit Internet holt sich die App neue Versionen selbst. |
| Konto und Server | Kein Konto, keine Anmeldung, kein eigener Server. |
| Gespeicherte Daten | Nur auf dem Gerät, im Speicher des Browsers: Name der Person, der das Handy gehört, Sprache, letzte Einstellung, Gewichte, Kennungen der Fragen aus der letzten Partie, unterbrochene Partie. Der zweite Name nur bis zum Ende der Partie. Wer die App vom Home-Bildschirm entfernt oder die Websitedaten löscht, verliert diese Daten. Ein Store-Release speichert zusätzlich den Kaufstatus. |
| Daten löschen | „Alle Daten zurücksetzen“ in den Einstellungen löscht alles außer dem Kaufstatus. |
| Datenschutz | Web-App: kein Tracking, keine Cookies, keine Anfragen an fremde Server; Schrift und Grafik-Engine kommen aus der App. GitHub Pages protokolliert Zugriffe wie jeder Webserver. Ob Impressum und Datenschutzerklärung nötig sind, prüft Christoph. Für einen Store-Release: Datenschutzerklärung in fünf Sprachen, Store-Angaben (App-Datenschutz bei Apple, Datensicherheit bei Google) zu dem, was das Werbe-SDK erfasst, keine Tracking-Abfrage (ATT). |
| Analyse | Keine eigenen Analyse-Tools in Version 1. Fehler zeigt in der Web-App nur die Konsole des Browsers. Ein Store-Release bekäme Absturzberichte über App Store Connect und die Play Console. |
| Darstellung | Heller und dunkler Modus nach Systemeinstellung, weil oft abends gespielt wird. |
| Barrierefreiheit | Dynamische Schriftgröße, Beschriftungen für VoiceOver und TalkBack, Kontrast nach WCAG AA, Tippflächen mindestens 44 × 44 pt (iOS) und 48 × 48 dp (Android). |
| Store-Prüfung | Screenshots und Prüfnotiz zeigen, was über eine Fragenliste hinausgeht: geführter Ablauf, Bewertung, Zusammenfassung, Timer. Das senkt das Risiko einer Ablehnung nach Apples Richtlinien 4.2 (Mindestfunktion) und 4.3 (Spam). |
| Werbeaussagen | Keine Aussage wie „wissenschaftlich bewiesen“. Die Ergebnisse der Studie sind umstritten. Kein Eindruck, die Autoren der Studie unterstützten die App. |
| Altersfreigabe | Vorschlag 12+. Endgültig über die Fragebögen beider Stores, die Werbung fließt dort mit ein. |
