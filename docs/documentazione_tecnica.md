# DOCUMENTAZIONE TECNICA PROGETTO BASI DI DATI INFORMATICA
> [name=Sarti Gabriele][time=Febbraio 20, 2023] [color=red]

:::info
Documentazione tecnica progetto "Piattaforma per la gestione degli esami universitari" per il corso "Basi di dati (informatica)" (a.a. 2023-2024, appello di febbraio).
Realizzato da Sarti Gabriele (matricola 975884).
:::

## Schema concettuale (ER) della base di dati
Se non visibile correttamente andare a questo [link](https://lucid.app/lucidchart/dbcb3024-ed24-41d4-94c1-fcdc5940c3da/view?page=0_0&invitationId=inv_f36de377-c205-4d4b-916f-32ee47b362ba#)
![](https://i.imgur.com/yhi9tAa.png)

Considerazioni sulle scelte progettuali:
- **gerarchia di generalizzazione per gli utenti**: tutti gli utenti sono dotati di un login con credenziali quali email e password, ho cosi deciso di accorpare queste informazioni insieme ad alcune sempre presenti quali nome e cognome nella entita' padre "utenti", avendo come chiave primaria l'id, la matricola era chiave ma solo per lo studente.
- **propedeuticita' degli insegnamenti**: viene rappresentata come una relazione ricorsiva tra insegnamenti, con cardinalita' (0,N) in quanto un insegnamento puo' non avere insegnamenti propedeutici o puo' averne fino ad N
- **mantenimento delle informazioni e delle carriere di studenti rimossi**: ho provvisto il mio schema er di una entita ex-studente legata da due relazioni esito e iscrizione per poter quindi salvare queste informazioni (come tabelle di storico)
- **ogni utente docente può avere al massimo 3 insegnamenti di cui è responsabile**: nello schema er questo concetto viene rappresentato da un vincolo di cardinalita tra docente ed insegnamento (0, 3) ossia che un docente puo' essere responsabile di massimo 3 insegnamenti
- **divisione iscrizione e valutazione/esito**: ho deciso di dividere questi due comportamenti con relazione diverse (esito ed iscrizione) in quanto considero che logicamente siano operazioni differenti 

## Ristrutturazione dello schema er
Per poterlo visionare nella sua completezza [link](https://lucid.app/lucidchart/49e53bd3-5083-4de7-864c-c556a4268e65/view?page=0_0&invitationId=inv_d03af04c-3a2e-48ab-a9ff-17f894879ea8#)

![](https://i.imgur.com/KNFkxTk.png)

Ho deciso di ristrutturare lo schema er mantenendo tutte le entita' con associazioni 1:1 per rappresentare il legame IS-A (ovvero il fatto che le entità figlie sono sottoinsiemi dell’entità padre e pertanto ogni loro istanza coincide (è) con una e una sola istanza dell’entità padre).

## Schema logico (relazionale) della base di dati

Ecco lo schema prodotto con la traduzione della schema er:
**Utenti**(**id**, email, password, nome, cognome, tipo)
**StoricoStudenti**(**Utenti**, matricola, motivo, *CorsiDiLaurea*)
**Studenti**(**Utenti**, matricola, *CorsiDiLaurea*)
**Docenti**(**Utenti**)
**Segreteria**(**Utenti**)
**Appelli**(**id**, data, orario, luogo, *Insegnamento*)
**CorsiDiLaurea**(**id**, nome, tipo, descrizione)
**Insegnamenti**(**codice**, nome, descrizione, anno, cfu, *CorsoDiLaurea*, *Docente*)
**Propedeuticita'**(***Insegnamento, InsegnamentoPropedeutico***)
**Esitiesami**(***Studente, Appello***, voto)
**StoricoEsiti**(***StoricoStudente, Appello***, voto)
**Iscrizioniesami**(***Studente, Appello***)
**StoricoIscrizioni**(***StudenteStorico, Appello***)

Appunti sulle motivazioni di questa traduzione da er a logico:
- le associazioni 1:1 is-a degli utenti sono state tradotte mettendo nei figli una chiave esterna che fa anche chiave primaria perche' entita' deboli
- per immatricolazioni di studenti (ed ex) le associazioni 1:N sono state tradotte mettendo nell entita' che ha cardinalita' max = 1 la chiave esterna
- per la proupedicita' si traducono come normali associazioni (in questo caso N:M) ma ridenominando le chiavi esterne in modo da evidenziarne il ruolo nell’associazione 
- la relazione appartiene si traduce come una 1:N con chiave esterna in appello
- la relazione esito si traduce come una normale relazione (N:M) molti a molti, la relazione esito con ex-studente viene rinominata in storicocarriera come da specifica e non e' altro che una duplicazione della tabella esito
- la relazione insegna/responsabile si traduce come una normale associazione 1:n con chiave esterna docente in insegnamento

## Scelte implementative significative/gestione casi limite

### Utilizzo di tipi di dato "particolari"
Per valorizzare al meglio la qualita' del progetto ho utilizzato per quanto concerne i codici univoci (id) il tipo di dato **UUID** e non **serial** ovvero un tipo di dato univoco ma non incrementale, (per ragioni di sicurezza).
Invece per quanto riguarda gli appelli la data tipo **DATE** e l'orario tipo **TIME**, per evitare di dover fare controlli e usare un tipo di dato appropiato alla colonna.
Inoltre in campi quali anno insegnamento, tipo utente, tipo corso di laurea, e motivo archiviazione studente, ho utilizzato degli **enum** (anche qua per evitare check ovvi)

```sql
CREATE TABLE utenti (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    ...
);

CREATE TABLE appelli (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    data DATE NOT NULL,
    orario TIME NOT NULL, 
    ...
)

CREATE TYPE TIPO_UTENTI AS ENUM ('studente', 'docente', 'segretario', 'ex_studente');
...
```

### Controllo insegnamenti docente 
Questa funzionalita' l'ho realizzata inserendo un trigger su insert ed update sulla tabella insegnamenti, quando vado ad inserire un nuovo insegnamento o ad aggiornarlo, controllo che il docente abbia massimo 3 insegnamenti oppure sollevo una eccezione.

```sql
CREATE OR REPLACE FUNCTION check_numeroinsegnamenti_docente() RETURNS TRIGGER 
LANGUAGE plpgsql
AS $$
    DECLARE _counter INTEGER;
    BEGIN
        SET search_path TO unimia;

        -- conto il numero di insegnamenti di cui il docente è responsabile (max 3 insegnamenti per docente)
        SELECT COUNT(*)
        FROM insegnamenti AS I
        WHERE I.docente = NEW.docente
        AND I.id != NEW.id
        INTO _counter;

        IF _counter = 3 THEN
            RAISE EXCEPTION 'Il docente è reponsabile già di 3 insegnamenti';
        END IF;

        RETURN NEW;
    END;
$$;

-- controlla che non esistano piu di 3 insegnamenti dove il docente insegna/responsabile
-- vedere sopra per la procedura
CREATE OR REPLACE TRIGGER i_u_numeroinsegnamenti_docente
    BEFORE INSERT OR UPDATE ON insegnamenti
    FOR EACH ROW
    EXECUTE PROCEDURE check_numeroinsegnamenti_docente();
```

### Mantenimento delle informazioni e delle carriere di studenti rimossi
Come spiegato in precedenza ho **duplicato le tabelle studente iscrizione ed esam**i per inserire i dati relativi agli studenti che non fanno piu parte dell'ateneo (rinuncia o laurea nel nostro caso).
**Non ho predisposto un trigger** per questa operazione in quanto ho ritenuto utile che sia la segreteria ha "decidere" il motivo dello studente per la sua archiviazione (vedere in seguito).

### Correttezza delle iscrizioni agli esami
Come scritto nella traccia "Ciascuno studente può iscriversi ad un esame solo se l’insegnamento è previsto dal proprio corso di laurea, e solamente se tutte le propedeuticità sono rispettate".
Questa operazione e' svolta ancora una volta da un **trigger** eseguito su insert sulla tabella iscrizioni il quale **controlla**:
- il cdl dello studente coincida con il cdl dell' insegnamento relativo alla iscrizione
- controlla che tutti gli insegnamenti propedeutici ad esso siano "passati"
- e che non ci si iscriva ad un appello nel "passato"

```sql=
CREATE OR REPLACE FUNCTION controllo_iscrizione() RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
    DECLARE 
        _insegnamento_appello varchar(6);
        _cdl_appello varchar(6);
        _cdl_studente varchar(6);
        _counter integer;
        _data_appello DATE;
    BEGIN
        SET search_path TO unimia;

        -- prendo il corso di laurea e l'insegnamento dell'appello
        SELECT I.id, I.corsodilaurea INTO _insegnamento_appello, _cdl_appello
        FROM appelli AS A
        INNER JOIN insegnamenti AS I ON I.id = A.insegnamento
        WHERE A.id = NEW.appello;

        -- prendo il corso di laurea dello studente che si vuole iscrivere
        SELECT S.corsodilaurea INTO _cdl_studente
        FROM studenti AS S 
        WHERE S.id = NEW.studente;

        -- controllo che il corso di laurea dello studente coincida con 
        -- il corso di laurea dell'insegnamento dell'appello 
        -- (perche' non e' possibile iscriversi ad esami di altri corsi di studio)
        IF _cdl_appello != _cdl_studente THEN
            RAISE EXCEPTION 'Iscrizione non possibile per corso di studio sbagliato';
        END IF;

        -- controllo se le propedeuticita' sono rispettate per potersi iscrivere
        -- prendo gli insegnamenti propedeutici e conto quelli che non hanno una valutazione positiva
        -- se almeno un record non ha una valutazione allora non mi posso iscrivere
        WITH RECURSIVE propedeutici AS (
            SELECT P.insegnamentopropedeutico
            FROM propedeuticita AS P
            WHERE insegnamento = _insegnamento_appello
            UNION 
            SELECT P2.insegnamentopropedeutico
            FROM propedeutici AS P
            INNER JOIN propedeuticita AS P2 ON P2.insegnamentopropedeutico = P2.insegnamento
        )
        SELECT COUNT(*) INTO _counter
        FROM propedeutici AS P 
        WHERE NOT EXISTS (
            SELECT *
            FROM get_voti_studente(NEW.studente) AS V
            WHERE V._id_insegnamento = P.insegnamentopropedeutico
            AND V._voto >= 18
        );

        IF _counter > 0 THEN
            raise exception 'Non sono state rispettate le propedeuticità';
        END IF;

        -- controllo che l'esame non sia nel passato
        SELECT data INTO _data_appello FROM appelli WHERE id = NEW.appello;
        IF NOW() > _data_appello THEN
            raise exception 'Non ci si puo iscrivere ad una data passata';
        END IF;

        RETURN NEW;
    END;
$$;

-- (Correttezza delle iscrizioni agli esami)
-- ci si puo' iscrivere solo se e' un appello riferito ad un insegnamento del proprio corso di studio
-- e se tutte le propedeuticita' sono rispettate
CREATE OR REPLACE TRIGGER i_controllo_iscrizione
    BEFORE INSERT 
    ON iscrizioniesami
    FOR EACH ROW
    EXECUTE PROCEDURE controllo_iscrizione();
```

### Correttezza del calendario d’esame
"Non è possibile programmare, nella stessa giornata, appelli per più esami dello stesso anno di un corso di laurea", questa funzionalita' viene garantita da un **trigger su insert nella tabella appelli**, in caso questo avvenga solleva una eccezione.

```sql 
CREATE OR REPLACE FUNCTION correttazza_calendario_appelli() RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
    DECLARE 
        _anno TIPO_ANNO;
        _cdl varchar(6);
        _counter integer;
    BEGIN
        SET search_path TO unimia;

        -- prendo anno e cdl dell'insegnamento relativo all'appello
        SELECT I.anno, I.corsodilaurea INTO _anno, _cdl
        FROM insegnamenti AS I 
        WHERE I.id = NEW.insegnamento;

        -- conto quanti appelli ci sono nella stessa giornata
        -- di insegnamenti dello stesso cdl dello stesso anno
        SELECT COUNT(*) INTO _counter
        FROM appelli AS A
        INNER JOIN insegnamenti AS I ON A.insegnamento = I.id
        WHERE I.corsodilaurea = _cdl AND I.anno = _anno AND A.data = NEW.data AND A.id != NEW.id;

        IF _counter >= 1 THEN
            RAISE EXCEPTION 'Appelli gia presenti in questa giornata';
        END IF;

      RETURN NEW;
    END;
$$;

-- (CORRETTEZZA DEL CALENDARIO DI ESAME)
-- trigger che controlla che nella stessa giornata non ci siano
-- appelli per più esami dello stesso anno di un corso di laurea.
CREATE OR REPLACE TRIGGER i_u_correttazza_calendario_appelli
    BEFORE INSERT OR UPDATE ON appelli
    FOR EACH ROW
    EXECUTE PROCEDURE correttazza_calendario_appelli();
```

### Produzione della carriera completa di uno studente
Per produrre la carriera di uno studente basta chiamare la funzione sottostante la quale interroga la tabella degli esiti degli esami, dato uno studente.
I voti di un exstudente invece sono presi da un altra funzione simile a questa (perche' ovviamente interroga un altra tabella).

```sql
-- (CARRIERA COMPLETA STUDENTE)
-- restituisce tutte le valutazioni per uno studente
CREATE OR REPLACE FUNCTION get_voti_studente(
    _studente uuid
)RETURNS TABLE (
    _id_insegnamento varchar(6),
    _nome_insegnamento text,
    _data DATE,
    _voto integer
)
LANGUAGE plpgsql
AS $$
    DECLARE 
    BEGIN    
        SET search_path TO unimia;

        RETURN QUERY
        SELECT I.id, I.nome, A.data, E.voto
        FROM esitiEsami AS E
        INNER JOIN appelli AS A ON A.id = E.appello
        INNER JOIN insegnamenti AS I ON I.id = A.insegnamento
        WHERE E.studente = _studente;
    END;
$$;
```

### Produzione della carriera valida di uno studente
Per produrre la carriera valida di uno stundente, bisogna chiamare la funzione sottostante che dato l'id dello studente restituisce tutti gli esiti "positivi" (>=18) piu' recenti (se ho passato un esame due volte prende quello con la datat piu' recente).
La carriera valida di un exstudente invece vengono restituiti da un altra funzione simile a questa (perche' ovviamente interroga un altra tabella).

```sql
-- restituisce la carrriera valida di uno studente
-- ossia restituisce tutti i voti degli esami piu recenti superati
CREATE OR REPLACE FUNCTION get_carriera_valida_studente(
    _studente uuid
)RETURNS TABLE (
    _id_insegnamento varchar(6),
    _nome_insegnamento text,
    _data DATE,
    _voto integer
)
LANGUAGE plpgsql
AS $$
    DECLARE 
    BEGIN    
        SET search_path TO unimia;

        RETURN QUERY
        SELECT I1.id ,I1.nome ,A1.data ,E1.voto
        FROM esitiesami AS E1
        INNER JOIN appelli AS A1 ON E1.appello = A1.id
        INNER JOIN insegnamenti AS I1 ON I1.id = A1.insegnamento
        WHERE E1.studente = _studente AND (I1.id, A1.data) IN (
            SELECT I2.id, MAX(A2.data)
            FROM esitiesami AS E2
            INNER JOIN appelli AS A2 ON E2.appello = A2.id
            INNER JOIN insegnamenti AS I2 ON I2.id = A2.insegnamento
            WHERE E2.studente = _studente
            GROUP BY I2.id
        )AND E1.voto >= 18;
    END;
$$;
```

### Produzione delle informazioni su un corso di laurea
Cio' viene reso disponibile da una funzione che dato l'id del corso di laurea restituisce tutti gli insegnamenti di quel corso, nel frontend e' presente un elenco a tendina dove e' possibile selezioanare il cdl, in seguito nel backend viene chiamata questa funzione per reperire le informazioni degli insegnamenti riguardo ed esso.

```sql
-- restituisce tutti gli insegnamenti di un corso di laurea
CREATE OR REPLACE FUNCTION get_all_insegnamenti(
    id_corso varchar(6)
) 
RETURNS TABLE(
    _id varchar(6),
    _nome text,
    _descrizione text,
    _anno TIPO_ANNO,
    _cfu smallint,
    _nome_docente text
) 
LANGUAGE plpgsql
AS $$
    DECLARE 
    BEGIN    
        SET search_path TO unimia;

        RETURN QUERY
        SELECT I.id, I.nome, I.descrizione, I.anno, I.cfu, CONCAT(U.nome, ' ', U.cognome)
        FROM insegnamenti AS I 
        INNER JOIN utenti AS U ON U.id = I.docente
        WHERE I.corsodilaurea = id_corso
        ORDER BY I.nome;
    END;
$$;
```

### Controllo disiscrizione per un esame
Lo studente ha la capacita' di disiscriversi da un esame, questo pero' puo' generare errori, infatti non dovrebbe essere possibile disiscriversi da un esame gia' sostenuto; cosi ho implementato un **trigger on delete sulla tabella iscrizioni**, che controlla che il giorno di oggi non sia dopo la data di appello.
```sql
CREATE OR REPLACE FUNCTION disicrizione_appello_studente() RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
    DECLARE 
        _data_appello DATE;
    BEGIN
        SET search_path TO unimia;

        -- controllo che il giorno dell'esame non sia passato
        -- ovviamente non e' possibile disiscriversi ad un esame se lo si sta sostenendo 
        -- oppure se e' gia passato 
        SELECT A.data INTO _data_appello
        FROM iscrizioniesami AS I 
        INNER JOIN appelli AS A ON A.id = I.appello
        WHERE I.studente = OLD.studente AND I.appello = OLD.appello;

        -- controllo che il giorno dell'esame sia in "futuro"
        IF NOW() >= _data_appello THEN
            RAISE EXCEPTION 'Non si puo disiscriversi da un esame passato';
        END IF;

        RETURN OLD;
    END;
    
$$;

-- Controlla se uno studente si puo' disiscrivere da un appello (iscrizione) 
-- solo quando la data dell'appello non e' gia passata
CREATE OR REPLACE TRIGGER d_disicrizione_appello_studente
    BEFORE DELETE ON iscrizioniesami 
    FOR EACH ROW 
    EXECUTE PROCEDURE disicrizione_appello_studente();
```

### Controllo propedeuticita' cicliche
Ho trovato necessario dover gestire dei **cicli nelle propedeuticita'** con cicli si intende una dei seguenti scenari (con -> "relazione di propedeuticita'"):
- A->A *(indetita')*
- A->B, B->A *(simmetria)*
- A->B, B->C, C->A *(transitivita')*

Nella base di dati cio' viene gestito attraverso un trigger su insert nella tabella delle propedeuticita':
```sql
CREATE OR REPLACE FUNCTION check_propedeuticita() RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
    DECLARE 
        _counter INTEGER;
    BEGIN
        SET search_path TO unimia;

        -- controllo se un insegnamento e' propedeutico a se stesso
        IF NEW.insegnamento = NEW.insegnamentopropedeutico THEN
            RAISE EXCEPTION 'Un insegnamento non puo essere propedeutico a se stesso (propedeuticita ciclica)';
        END IF;

        -- controllo se ho un ciclo di propedeuticita'
        WITH RECURSIVE propedeutici AS (
            -- caso base  
            -- trovo tutte le propedeuticita' che ha l'insegnamento propedeutico che ho in NEW
            SELECT P.insegnamentopropedeutico
            FROM propedeuticita AS P
            WHERE P.insegnamento = NEW.insegnamentopropedeutico
        UNION
            -- passo ricorsivo
            -- cerca dalla tabella temporanea 
            SELECT P2.insegnamentopropedeutico
            FROM propedeutici AS P
            INNER JOIN propedeuticita AS P2 ON P.insegnamentopropedeutico = P2.insegnamento
        )
        SELECT COUNT(*) INTO _counter FROM propedeutici AS P    
        WHERE P.insegnamentopropedeutico = NEW.insegnamento;

        IF _counter > 0 THEN
            raise exception 'Propedeuticità ciclica trovata';
        END IF;

        RETURN NEW; -- se i controlli vanno bene faccio la insert/update
    END;
$$;

CREATE OR REPLACE TRIGGER i_u_check_propedeuticita
    BEFORE INSERT OR UPDATE ON propedeuticita
    FOR EACH ROW
    EXECUTE PROCEDURE check_propedeuticita();
```

### Controllo anno insegnamento in base al "tipo" di cdl
Un altra gestione eseguita e' legata alla correttezza tra l'anno di erogazione dell'insegnamento messo in relazione al tipo di cdl (per esempio "triennale")
Gestito con un trigger su insert ed update sulla tabella degli insegnamenti:
```sql
CREATE OR REPLACE FUNCTION check_anno_insegnamento() RETURNS TRIGGER 
LANGUAGE plpgsql
AS $$
    DECLARE 
        _corso text;
    BEGIN
        SET search_path TO unimia;

        -- prendo il tipo ('triennale'...) del corso di laurea dell'insegnamento che sto per inserire/modificare
        SELECT C.tipo
        FROM corsiDiLaurea AS C
        WHERE C.id = NEW.corsoDiLaurea
        INTO _corso;

        IF _corso = 'triennale' AND NEW.anno IN ('4', '5') THEN
            RAISE EXCEPTION 'Anno insegnamento non valido per corso triennale';
        END IF;

        IF _corso = 'magistrale' AND NEW.anno IN ('3', '4', '5') THEN
            RAISE EXCEPTION 'Anno insegnamento non valido per corso magistrale';
        END IF;

        RETURN NEW; -- se i controlli vanno bene faccio la insert/update
    END;
$$;

-- verifica che l'anno insegnamento in cui e' erogato l'insegnamento che sta per essere inserito/modificato
-- deve essere compreso tra 1 e 3 per i cdl triennali e tra 1 e 2 per i cdl magistrali (estermi inclusi)
CREATE OR REPLACE TRIGGER i_u_check_anno_insegnamento
    BEFORE INSERT OR UPDATE ON insegnamenti
    FOR EACH ROW
    EXECUTE PROCEDURE check_anno_insegnamento();
```

## Esauriente descrizione delle funzioni realizzate

### Procedure
Elenco procedure:
- add_student: aggiunge uno studente
- update_student: modifica uno studente
- remove_student: elimina uno studente
- add_teacher: aggiunge un docente
- update_teacher: modifica il docente
- delete_docente: elimina il docente
- add_secretary: aggiunge un segretario
- add_cdl: aggiunge un corsi di studi
- update_cdl: modifica un corsi di studi
- delete_cdl: elimina un corso di studi
- edit_password: modifica la password di un utente
- add_insegnamento: aggiunge un insegnamento
- update_insegnamento: modifica un insegnamento
- delete_insegnamento: elimina un insegnamento
- add_appello: aggiunge un appello
- update_appello: modifica un appello
- delete_appello: cancella un appello
- add_iscrizione_studente: aggiunge una iscrizione per uno studente
- add_valutazione_esame: da una valutazione ad uno studente per un esame
- disiscriviti_studente: lo studente si disiscrive ad un appello
- archivia_studente: archivia uno studente per una motivazione

### Funzioni
Ecco le funzioni:
- get_student: restituisce uno studente
- get_all_students: restituisce tutti gli studenti
- get_teacher: restituisce un docente 
- get_all_teachers: restituisce tutti i docenti 
- get_cdl: restituisce un corso di studi
- get_all_courses: restituisce tutti i corsi di studi
- get_insegnamento: restituisce un insegnamento
- get_all_insegnamenti: restituisce tutti gli insegnamenti 
- get_all_insegnamenti_propedeutici: restituisce tutti gli insegnamenti propedeutici ad un insegnamento (input)
- get_insegnamenti_docente: restituisce tutti gli insegnamenti di cui il docente e' responsabile
- get_appelli_docente: restiuisce tutti gli appelli degli insegnamenti di cui il docente e' responsabile
- get_appello: restituisce un appello
- get_all_appelli: restituisce tutti gli appelli di uno studente
- get_all_iscrizioni: restituisce tutte le iscrizioni di uno studente
- get_esami_valutare_docente: restituisce gli esami da valutare degli studenti iscritti ai suoi appelli 
- get_voti_studente: restituisce la carriera completa per uno studente
- get_voti_exstudente: restituisce la carriera completa per un ex-studente
- get_carriera_valida_studente: restituisce la carriera valida per uno studente
- get_carriera_valida_exstudente: restituisce la carriera valida per un ex-studente

### Trigger
Ecco i trigger
- i_u_numeroinsegnamenti_docente: controlla il numero degli insegnamenti del docente
- i_u_check_anno_insegnamento: controlla l'anno dell'erogazione di un insegnamento
- i_u_check_propedeuticita: controlla i cicli di propedeuticita'
- i_u_correttazza_calendario_appelli: controlla il calendario degli appelli
- d_disicrizione_appello_studente: controlla la disiscrizione per uno studente
- i_controllo_iscrizione: controlla la iscrizione per un esame da parte di uno studente

## Prove di funzionamento

### Studente
Una volta andati nel proprio browser di riferimento a http://localhost/ProgettoBasi/ ci troveremo la sequente schermata, loggiamo con uno studente di prova e selezioniamo dal menu a tendina che siamo uno studente, e poi clicchiamo su entra:

![](https://i.imgur.com/UOoVUlW.png)

Veniamo quindi portati alla homepage del sito, loggati come studente:

![](https://i.imgur.com/5znzq7O.png)

Possiamo sia navigare con la navbar o con il riguadro sottostante, per esempio nella navbar clicchiamo sulla sezione "corsi di laurea", questo ci permette selezionando opportunamento il corso di laurea e premendo il bottone di visionare tutti gli insegnamenti disponibili per esso e le relative informazioni:

![](https://i.imgur.com/wICrYYP.png)

Selezionando invece la voce "profilo" dalla navbar e' possibile osservare le proprie informazioni e credenziali e premendo il pulsante cambia password e' possibile modificarla:

![](https://i.imgur.com/IarcfKc.png)
![](https://i.imgur.com/W3Xw5tQ.png)

Tornando invece nella home e cliccando nel riquadro "iscrizioni per un nuovo esame" e' possibile iscriversi ad un nuovo esame tra quelli disponibili:

![](https://i.imgur.com/LHf4W7p.png)

Se l'esame e' gia passato oppure se non rispetta le propedeuticita' verra' visualizzato un banner con un messaggio di errore.
Tornando alla home e muovendoci alle "iscrizioni confermate" e' possibile visualizzare le iscrizioni effettuate dove e' possibile disiscriversi solo per quelle future:

![](https://i.imgur.com/QKnl90P.png)

Tornando ancora una volta alla home e cliccando sul riquadro "carriera completa" e' possibile vedere tutte le votazioni ricevute per gli esami sostenuti
![](https://i.imgur.com/3IDjiIW.png)

Invece andando sulla "carriera valida" sempre dalla home e' possibile vedere tutte le votazioni valida >=18 recenti:

![](https://i.imgur.com/WElGnf4.png)

In seguito possiamo uscire/logout dalla navbar "esci"

### Ex-studente
Una volta andati nel proprio browser di riferimento a http://localhost/ProgettoBasi/ ci troveremo la sequente schermata, loggiamo con un ex-studente di prova e selezioniamo dal menu a tendina che siamo un exstudente, e poi clicchiamo su entra:

![](https://i.imgur.com/lWHNUZ6.png)

Entriamo cosi nella home dell'ex-studente (simile a quella di uno studente), e vedremo che e' prensente soltanto "carriera completa" e "carriera valida", identici a quelli dello studente (visto sopra)

![](https://i.imgur.com/GuQrheq.png)

Anche qui dalla navbar fare il logout.

### Docente
Una volta andati nel proprio browser di riferimento a http://localhost/ProgettoBasi/ ci troveremo la sequente schermata, loggiamo con un docente di prova e selezioniamo dal menu a tendina che siamo un docente, e poi clicchiamo su entra:

![](https://i.imgur.com/4GJUMgL.png)

Siamo cosi entrati nella home dove possiamo visualizzare alcuni dati personali
![](https://i.imgur.com/mxBtzY4.png)

Usando la navbar oppure il riguardo andiamo su "visualizza insegnamenti" in questa pagina si visualizzano gli insegnamenti di cui il docente loggato e' responsabile/insegna

![](https://i.imgur.com/QCvxAD0.png)

Tornando alla home ora andiamo a "crea appello", in questa pagine e' possibile creare un nuovo appello se dati sbagliati verremo avvertiti con un banner di errore

![](https://i.imgur.com/QOJSLD7.png)

Per vedere invece tutti gli appelli del docente possiamo andare in "i miei appelli" oppure dalla navbar "calendario esami", sempre in questa pagina e' possibile sia modificare che eliminare un appello.

![](https://i.imgur.com/80LYPjF.png)

Infine e' possibile registrare un voto per un appello di uno studente nella sezione "registra voto/esiti", qua verranno visualizzati solo gli studenti che hanno sostenuto l'esame (solo gli appelli "passati") e sara' possibile assegnare un voto ad essi per ogni studente iscritto.

### Segreteria
Una volta andati nel proprio browser di riferimento a http://localhost/ProgettoBasi/ ci troveremo la sequente schermata, loggiamo con un segretario di prova e selezioniamo dal menu a tendina che siamo un segretario, e poi clicchiamo su entra:

![](https://i.imgur.com/QbZBvl3.png)

Se login corretto allora visualizzeremo la home della segreteria e utilizzando l'apposita navbar potremo navigare

![](https://i.imgur.com/FmOyq2J.png)

Nella sezione "studente" alla voce "inserisci studente" della navbar se cliccata ci portera' a questa schermata dove potremo creare un nuovo studente (stesso discorso per inserire un docente), anche qui se i dati sono sbagliati ci sara' un banner di errore

![](https://i.imgur.com/q0yHIql.png)
![](https://i.imgur.com/lT5F2b0.png)

Se invece andiamo alla voce "visualizza studenti" vedremo tutti gli studenti dell'ateneo potremmo archiviarli con il bottone "elimina", modificarli con il bottone "modifica" ci porta ad una pagina con i dati gia' compilati da modificare (stesso discorso per i docenti), o produrre le loro carriere sia quella completa che quella valida

![](https://i.imgur.com/nl6NXjV.png)

![](https://i.imgur.com/ouGGtoE.png)

Nella sezione "corsi di laurea" potremmo vedere tutti i corsi di laurea modificarli ed eliminarli oppure nella sezione crea corso potremmo crearne uno nuovo

![](https://i.imgur.com/pwx9nL4.png)

![](https://i.imgur.com/DoXw9qi.png)

Nella sezione "insegnamenti" e' invece possibile sia cercare gli insegnamenti di un corso di studio, potendoli inoltre sia eliminare che modificare, che la possibilita' di crearne uno nuovo

![](https://i.imgur.com/Xyd8lSA.png)

![](https://i.imgur.com/Z7Ie7ZC.png)

Infine come per lo studente e per il docente c'e' sia la sezione profilo che la funzione di logout.















