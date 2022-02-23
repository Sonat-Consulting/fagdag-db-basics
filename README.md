FAGDAG-DB-BASICS
----------------------

Velkommen til fagdag om DB basics.  Dine hjelpere i dag er Jonas og Christian.  Hvis du står fast på noe så ta kontakt.

Verktøyene for dagen er :  
Datagrip for JetBrains (<https://www.jetbrains.com/datagrip/download/>)  
Docker og Docker-compose

## Installering

### Datagrip

Last ned og installer som normalt fra [Jetbrains](https://www.jetbrains.com/datagrip/download/), 30 dagers free trial holder for fagdagen.

### Start and reset databases

For å starte databasene så kjør denne kommandoen, den kan kjøres flere ganger hvis du ønsker å stille databasene tilbake.

```docker-compose up -d --force-recreate -V```

### Kontakt med basen

Etter du har kjørt ```docker-compose``` kan du koble deg på basen i Datagrip.

1. Start Datagrip
2. Fra menyen velg "File->New->Data Source->PostgresSql"
   1. Legg inn følgende informasjon:
    * Host: localhost
    * User: test
    * Passord: test
    * Database: world
  
## Oppgave 1

Past-Christian har vært lat igjen, databasen mangler flere ting.  Nå ønsker Future-Christian å ta den i bruk.  Legg in constraints, nøkler eller lignende for å stoppe Future-Christian fra å gjøre ugagn.  

For å starte kampen, åpne et consoll mot ```world``` databasen og utfør kommandoen:  

```call usp_Battle()```

Gjør nødvendige endringer i basen og utfør denne kommandoen på nytt. Gjenta til du har fått beskjed om at du har vunnet.
