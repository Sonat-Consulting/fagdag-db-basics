## Pizza mafiaen har slått seg på "iskrem"

![Ice cream sellers](johaug-guns.jpg)

### 24/7 iskrem
Vi får ordrer fra byen hele døgnet, 

### Skrote butikken
Om vi må skrote butikken kjapt så er ```docker-compose up -d --force-recreate -V``` vår venn.

### ice_cream_orders tabell

| id (PKEY) | order_id                               | restaurant | product_id | state |
|-----------|----------------------------------------|------------|------------|-------|
| 100001    | "937a6571-2ef8-4e01-b0f6-f799c4a95c1a" | "bjørgens" | 10002      | 1     | 
| 100002    | "a623ac40-b5ed-486b-8673-b0afb0a49c40" | "nortugs"  | 10003      | 1     |

### Deduplisere ordrer
Ordrer kommer med en unik ```order_id ``` som er forventet å være en unik tekst.
Vi vil deduplisere ordrene, slik at to ordrer med samme ```order_id``` aldri vil bli registrert.
Om de duplikate ordrene er like så vil vi ignorere den ekstra ordren, dersom de er ulike ønsker vi å logge slik at
ordrene kan sjekkes.


### Aldri ta inn mer ordrer enn vi har tilgjengelig iskrem
Mafiaen tar ikke lett på ordrer som ikke leveres, vi må derfor aldri ta inn flere ordrer enn vi har tilgjengelig.
Vi har en tabell som til en hver tid sier hvor mye iskrem vi ikke har tatt imot ordrer av av hver type.

### ice_cream_inventory tabell

| product_id (PKEY) | name         | available |
|-------------------|--------------|-----------|
| 10001             | "strawberry" | 10        |  
| 10002             | "vanilla"    | 5         |


Kunne vi brukt: ```select count(*) from ice_cream_orders where state=1``` og hatt en grense som ikke endret seg.

For å finne produkt id gjør vi første ```select product_id,available from ice_cream_inventory where name=? ```

Utfør et forsøk som viser at naiv bruk av```update ice_cream_inventory set available=available - 1 where product_id=?```
ikke er så lurt. 

Kan vi endre isolation og få det til å fungere? Når vil det være lurt?
Finnes det andre bedre løsninger?

### Prosessering av ordrer
Vi vil gjerne ta tak i alle ordrer som ikke er prosessert, og prosessere de.

### Vi vil ha en rapport av alle ordrer på tidspunkt X