# MANUALE UTENTE PROGETTO BASI DI DATI INFORMATICA

:::info
Manuale utente progetto "Piattaforma per la gestione degli esami universitari" per il corso "Basi di dati (informatica)" (a.a. 2023-2024, appello di febbraio).
Realizzato da Sarti Gabriele (matricola 975884).
:::

## Requisiti
Requisiti minimi di funzionamento:
- php (versione 8+)
- postgres (versione 15+)
- webserver (possibile usare anche quello integrato di php)

## Inizializzazione
Istruzioni passo passo:
- clonare la repo github
- fare il restore del dump sql nella cartella dump
- nella cartella conf aggiugere le credenziali
- per accedere al db locale: psql -U postgres -h localhost unimia (controllare il pg_hba.conf)
- accedere all app attraverso il web server