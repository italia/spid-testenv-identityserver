# SPID TEST ENVIRONMENT IDENTITY SERVER

SPID Test Environment è rivolto ai Service Provider che vogliono testare la propria integrazione con SPID senza avere a disposizione identità SPID reali.
Consiste in un Identity Provider da far girare in locale o su un proprio server, in cui si possono liberamente configurare delle identità di test.

L'ambiente si compone di due elementi:
* l'Identity Server vero e proprio, basato su [WSO2-is](https://github.com/wso2/product-is), [(repository github)](https://github.com/italia/spid-testenv-identityserver);
* un backoffice web basato su Node.js che offre un'interfaccia semplificata per la configurazione del Service Provider sull'IS e la creazione delle identità [(repository github)](https://github.com/italia/spid-testenv-backoffice).

## Docker

Per l'installazione con Docker fare riferimento al repository [spid-testenvironment](https://github.com/italia/spid-testenvironment)

## Installazione senza Docker

### Prerequisiti

* Java 7 o 8

### Configurazione

```
...
```

### Avvio

Avviare WSO2-is con il seguente comando (dalla root dell'ambiente di test):

```
$ sh apps/spid-idp-is/bin/wso2server.sh start
```
per ambienti windows utilizzare il .bat

## Disponibilità del servizio

L'avvio può richiedere anche qualche minuto.
L'interfaccia di amministrazione dell'identity server sarà disponibile in https://localhost:9443/ (utente: admin, password: admin) 
ma **non è necessario** aprirla poiché le attività di configurazione saranno disponibili su https://localhost:8080 (backoffice ad accesso libero) [(repository github)](https://github.com/italia/spid-testenvironment-backoffice)