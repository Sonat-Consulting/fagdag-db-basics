Iskrembutikk
-----------------

![Ice cream sellers](pizza-tycoon.jpg)

### Skrote butikken
Om vi må skrote butikken kjapt så er ```docker-compose up -d --force-recreate -V``` vår venn.

### Opprette tabeller
Tabeller som trengs lages ved å kjøre ```tables.sql```

### Felles for oppgavene
Oppgavene anntar at ordrer kan registreres samtidig, og at samme
ordre kan bli gjentatt flere ganger.

## Oppgave 1

### Krav
* Ordrer kommer med en unik ```order_id ``` som er forventet å være en unik tekst.
* Deduplisere ordrene, slik at to ordrer med samme ```order_id``` aldri vil bli registrert.
* Om de duplikate ordrene er like så vil vi ignorere den ekstra ordren, dersom de er ulike ønsker vi å logge slik at
ordrene kan sjekkes.
* Tabellen for ordrer vises under, for øyeblikket kan vi ignorere restaurant,product_id og state, og bruke ('noe',1,1) i disse.
``` oppgave1.sql ``` inneholder et eksempel på en insert i en transaksjon.

### ice_cream_orders tabell

| id (PKEY) | order_id                               | restaurant | product_id | state |
|-----------|----------------------------------------|------------|------------|-------|
| 1         | "937a6571-2ef8-4e01-b0f6-f799c4a95c1a" | "villani"  | 1          | 1     | 
| 2         | "a623ac40-b5ed-486b-8673-b0afb0a49c40" | "milano"   | 2          | 1     |

Gi et forslag til en flyt, samt transaksjoner og eller endring på tabellene som vil oppfylle kravene.

Finn gjerne flere løsninger.

## Oppgave 2

### Krav
* Kundene tar ikke lett på ordrer som ikke leveres, vi må derfor ALDRI 
ta imot flere ordrer enn vi har tilgjengelige produkter.
* Vi har en tabell som sier hvor mye iskrem vi har tilgjengelig av hver type, og hver ordre har en foreign
key som peker til produktet. Denne tabelle ser slik ut.

### ice_cream_inventory tabell

| product_id (PKEY) | name         | available |
|-------------------|--------------|-----------|
| 1                 | "strawberry" | 10        |  
| 2                 | "vanilla"    | 5         |

Lag et forslag til en flyt og transaksjoner når vi mottar ordren, som vil overholde kravene fra
oppgave 1 og oppgave 2.

Finn gjerne flere løsninger.


