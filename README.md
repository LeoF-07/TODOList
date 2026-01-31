# ToDo List

ToDo List - Salva i tuoi impegni o ciò che preferisci, organizzali in liste e spunta le Task quando le completi, ToDo List è l'app perfetta se non vuoi scordarti di nulla!

## Screenshots
<img src="screenshots/Screenshots.png" alt="Screenshots" width="900">

## Funzionamento

Questa applicazione ti consente di salvare impegni, tasks e ciò che si vuole memorizzare in apposite liste.

Quando l'utente completa quella task gli basta aprire l'app e spuntarla. La sezione Stats poi mostra sia le statistiche globali sia quelle di ogni lista in modo da agevolare la gestione degli impegni.


## Scelte di sviluppo

L'applicazione si compone di due Tab:

* Lists o Tasks. Questo Tab viene mostrato all'apertura dell'applicazione e mostra l'elenco delle liste. Quando si preme su una lista il tab cambia il suo nome in Tasks e mostra l'elenco delle task presenti in quella lista.
* Stats. Se ci si trova nel Tab delle liste esso mostra le statistiche generali di completamento e una panoramica sul completamento delle singole liste. Invece se ci si trova su una specifica lista mostra le statistiche specifiche di quella lista e le task che mancano da completare.

Vengono usati due provider:
* Il primo che gestisce le liste, le tasks e le statistiche e tutti i cambiamenti che le riguardano
* Il secondo gestisce le pagine da visualizzare (liste, tasks, statistiche generali, statistiche specifiche)

## Requisiti

- Flutter SDK
- Android Studio
- Visual Studio Code

L'ambiente deve essere configurato correttamente, il seguente comando da digitare sul prompt dei comandi fornirà  indicazioni sullo stato configurazione:
```bash
flutter doctor
```

## Download del progetto

È possibile scaricare questo progetto selezionando il percorso desiderato dal prompt dei comandi e digitando:
```bash
git clone https://github.com/LeoF-07/TODOList.git
```
L'applicazione client funziona per i dispositivi Android.
Se i [Requisiti](#Requisiti) sono rispettati sarà  possibile modificare il progetto con Android Studio o Visual Studio Code ed emularlo.


## Emulazione dell'applicazione

L'emulazione dell'applicazione può avvenire o con i dispositivi virtuali che Android Studio mette a disposizione oppure su un dispositivi fisico personale. Se si sceglie di eseguire il debug con questa seconda opzione è necessario seguire questi passaggi:
1. Collegare il dispositivo al PC tramite un cavo USB.
2. Assicurarsi che il **debug USB** sia attivo nelle Opzioni sviluppatore del dispositivo Android.
3. Verificare che il dispositivo sia riconosciuto e ottenere l'id del dispositivo con:
```bash
futter devices
```
4. Digitare nel prompt dei comandi all'interno della cartella del progetto:
```bash
flutter run -d <device-id>
```

## Creazione APK

L'APK può essere creato direttamente del Menu di Android Studio nella sezione Build, oppure è sufficiente digitare questo comando nel prompt dei comandi all'interno della cartella del progetto:
```bash
flutter build apk --release
```

Nella sezione [Releases](https://github.com/LeoF-07/Briscola/releases) della repository è presente l'APK da scaricare senza bisogno di aprire il progetto con un IDE.



Trasferendo l'apk su un dispositivo Android potrà  essere scaricato e l'applicazione sarà  pronta all'uso.


## Autore

Leonardo Fortin