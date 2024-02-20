--
-- PostgreSQL database dump
--

-- Dumped from database version 16.1 (Ubuntu 16.1-1.pgdg22.04+1)
-- Dumped by pg_dump version 16.1 (Ubuntu 16.1-1.pgdg22.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: unimia; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA unimia;


ALTER SCHEMA unimia OWNER TO postgres;

--
-- Name: tipo_anno; Type: TYPE; Schema: unimia; Owner: postgres
--

CREATE TYPE unimia.tipo_anno AS ENUM (
    '1',
    '2',
    '3',
    '4',
    '5'
);


ALTER TYPE unimia.tipo_anno OWNER TO postgres;

--
-- Name: tipo_corso_laurea; Type: TYPE; Schema: unimia; Owner: postgres
--

CREATE TYPE unimia.tipo_corso_laurea AS ENUM (
    'triennale',
    'magistrale',
    'magistrale a ciclo unico'
);


ALTER TYPE unimia.tipo_corso_laurea OWNER TO postgres;

--
-- Name: tipo_motivo; Type: TYPE; Schema: unimia; Owner: postgres
--

CREATE TYPE unimia.tipo_motivo AS ENUM (
    'rinuncia',
    'laurea'
);


ALTER TYPE unimia.tipo_motivo OWNER TO postgres;

--
-- Name: tipo_utenti; Type: TYPE; Schema: unimia; Owner: postgres
--

CREATE TYPE unimia.tipo_utenti AS ENUM (
    'studente',
    'docente',
    'segretario',
    'ex_studente'
);


ALTER TYPE unimia.tipo_utenti OWNER TO postgres;

--
-- Name: add_appello(character varying, date, time without time zone, text); Type: PROCEDURE; Schema: unimia; Owner: postgres
--

CREATE PROCEDURE unimia.add_appello(IN _insegnamento character varying, IN _data date, IN _ora time without time zone, IN _luogo text)
    LANGUAGE plpgsql
    AS $$
    BEGIN

        SET search_path TO unimia;

        IF Now() > _data THEN
            raise exception E'Appello nel passato non possibile';
        END IF;

        INSERT INTO appelli(insegnamento, data, orario, luogo)
        VALUES (_insegnamento, _data, _ora, _luogo);

    END;
$$;


ALTER PROCEDURE unimia.add_appello(IN _insegnamento character varying, IN _data date, IN _ora time without time zone, IN _luogo text) OWNER TO postgres;

--
-- Name: add_cdl(character varying, text, unimia.tipo_corso_laurea, text); Type: PROCEDURE; Schema: unimia; Owner: postgres
--

CREATE PROCEDURE unimia.add_cdl(IN _id character varying, IN _nome text, IN _tipo unimia.tipo_corso_laurea, IN _desc text)
    LANGUAGE plpgsql
    AS $$
    BEGIN    
        SET search_path TO unimia;

        -- inserimento del cdl
        INSERT INTO corsiDiLaurea(id,nome,tipo,descrizione) VALUES (_id, _nome, _tipo, _desc);
    END;
$$;


ALTER PROCEDURE unimia.add_cdl(IN _id character varying, IN _nome text, IN _tipo unimia.tipo_corso_laurea, IN _desc text) OWNER TO postgres;

--
-- Name: add_insegnamento(character varying, text, text, unimia.tipo_anno, smallint, character varying, uuid, character varying[]); Type: PROCEDURE; Schema: unimia; Owner: postgres
--

CREATE PROCEDURE unimia.add_insegnamento(IN _id character varying, IN _nome text, IN _descrizione text, IN _anno unimia.tipo_anno, IN _cfu smallint, IN _corsodilaurea character varying, IN _docente uuid, IN _propedeutici character varying[])
    LANGUAGE plpgsql
    AS $$
    DECLARE
        _propedeutico varchar(6);
    BEGIN
        SET search_path TO unimia;

        -- inserisco il nuovo insegnamento
        INSERT INTO insegnamenti(id, nome, descrizione, anno, cfu, corsoDiLaurea, docente) VALUES (_id, _nome, _descrizione, _anno, _cfu, _corsoDiLaurea, _docente);
    
        IF _propedeutici IS NOT NULL THEN
            -- aggiungo gli esami propedeutici per l'insegnamento inserito
            FOREACH _propedeutico IN ARRAY _propedeutici LOOP
                INSERT INTO propedeuticita VALUES (_id, _propedeutico);
            END LOOP;
        END IF;
    END;
$$;


ALTER PROCEDURE unimia.add_insegnamento(IN _id character varying, IN _nome text, IN _descrizione text, IN _anno unimia.tipo_anno, IN _cfu smallint, IN _corsodilaurea character varying, IN _docente uuid, IN _propedeutici character varying[]) OWNER TO postgres;

--
-- Name: add_iscrizione_studente(uuid, uuid); Type: PROCEDURE; Schema: unimia; Owner: postgres
--

CREATE PROCEDURE unimia.add_iscrizione_studente(IN _id_appello uuid, IN _id_studente uuid)
    LANGUAGE plpgsql
    AS $$
    BEGIN
        SET search_path TO unimia;

        -- aggiungo l'iscrizione dell appello per lo studente
        INSERT INTO iscrizioniesami(studente, appello) VALUES (_id_studente, _id_appello);


    END;
$$;


ALTER PROCEDURE unimia.add_iscrizione_studente(IN _id_appello uuid, IN _id_studente uuid) OWNER TO postgres;

--
-- Name: add_secretary(text, text, text, text); Type: PROCEDURE; Schema: unimia; Owner: postgres
--

CREATE PROCEDURE unimia.add_secretary(IN _email text, IN _password text, IN _nome text, IN _cognome text)
    LANGUAGE plpgsql
    AS $$
    DECLARE _id uuid;
    BEGIN    
        SET search_path TO unimia;

        -- inserimento delle credenziali del segretario/a
        INSERT INTO utenti(email, password, tipo, nome, cognome) VALUES (_email, _password, 'segretario', _nome, _cognome) RETURNING id INTO _id;

        -- inserimento del docente
        INSERT INTO segreteria(id) VALUES (_id);
    END;
$$;


ALTER PROCEDURE unimia.add_secretary(IN _email text, IN _password text, IN _nome text, IN _cognome text) OWNER TO postgres;

--
-- Name: add_student(text, text, text, text, character); Type: PROCEDURE; Schema: unimia; Owner: postgres
--

CREATE PROCEDURE unimia.add_student(IN _email text, IN _password text, IN _nome text, IN _cognome text, IN _cdl character)
    LANGUAGE plpgsql
    AS $$
    DECLARE 
        _id uuid;
    BEGIN    
        SET search_path TO unimia;

        -- inserimento delle credenziali dello studente
        INSERT INTO utenti(email, password, tipo, nome, cognome) VALUES (_email, _password, 'studente', _nome, _cognome) RETURNING id INTO _id;

        -- inserimento dello studente (guardare il trigger che genera la matricola)
        INSERT INTO studenti(id, corsoDiLaurea) VALUES (_id, _cdl);
    END;
$$;


ALTER PROCEDURE unimia.add_student(IN _email text, IN _password text, IN _nome text, IN _cognome text, IN _cdl character) OWNER TO postgres;

--
-- Name: add_teacher(text, text, text, text); Type: PROCEDURE; Schema: unimia; Owner: postgres
--

CREATE PROCEDURE unimia.add_teacher(IN _email text, IN _password text, IN _nome text, IN _cognome text)
    LANGUAGE plpgsql
    AS $$
    DECLARE _id uuid;
    BEGIN    
        SET search_path TO unimia;

        -- inserimento delle credenziali del docente
        INSERT INTO utenti(email, password, tipo, nome, cognome) VALUES (_email, _password, 'docente', _nome, _cognome) RETURNING id INTO _id;

        -- inserimento del docente
        INSERT INTO docenti(id) VALUES (_id);
    END;
$$;


ALTER PROCEDURE unimia.add_teacher(IN _email text, IN _password text, IN _nome text, IN _cognome text) OWNER TO postgres;

--
-- Name: add_valutazione_esame(uuid, uuid, smallint); Type: PROCEDURE; Schema: unimia; Owner: postgres
--

CREATE PROCEDURE unimia.add_valutazione_esame(IN _id_appello uuid, IN _id_studente uuid, IN _voto smallint)
    LANGUAGE plpgsql
    AS $$
    DECLARE _data_appello DATE;
    BEGIN
        SET search_path TO unimia;

        -- prendo la data dell appello
        SELECT A.data INTO _data_appello FROM appelli AS A WHERE A.id = _id_appello; 

        -- controllo se lo posso valutare
        IF _data_appello > Now() THEN
            raise exception E'Errore appello da valutare nel futuro';
        END IF;

        -- metto la valutazione
        INSERT INTO esitiesami(studente, appello, voto) VALUES (_id_studente, _id_appello, _voto);
    END;
$$;


ALTER PROCEDURE unimia.add_valutazione_esame(IN _id_appello uuid, IN _id_studente uuid, IN _voto smallint) OWNER TO postgres;

--
-- Name: archivia_studente(unimia.tipo_motivo, uuid); Type: PROCEDURE; Schema: unimia; Owner: postgres
--

CREATE PROCEDURE unimia.archivia_studente(IN _motivazione unimia.tipo_motivo, IN _id uuid)
    LANGUAGE plpgsql
    AS $$
    DECLARE 
        _studente unimia.studenti%ROWTYPE;
    BEGIN

    SET search_path TO unimia;

    -- salva i dati dello studente
    SELECT * INTO _studente FROM studenti WHERE id = _id;

    -- inserisce nell'archivio studenti quello appena eliminato con la motivazione personalizzata
    INSERT INTO storicostudenti
    VALUES (_studente.id, _studente.matricola, _motivazione , _studente.corsodilaurea);

    -- aggiorno il tipo di utente 
    UPDATE utenti SET tipo = 'ex_studente' WHERE id = _id;

    -- inserisco nell'archivio le vecchie iscrizioni dello studente
    WITH iscrizioni_studente AS (
        DELETE FROM iscrizioniesami AS I
        WHERE I.studente = _id
        RETURNING I.*
    )
    INSERT INTO storicoiscrizioni SELECT * FROM iscrizioni_studente;

    -- inserisco nell'archivio le vecchie valutazioni dello studente
    WITH valutazioni_studente AS (
        DELETE FROM esitiesami AS E
        WHERE E.studente = _id
        RETURNING E.*
    )
    INSERT INTO storicovalutazioni SELECT * FROM valutazioni_studente;

    -- elimina lo studete
    DELETE FROM studenti WHERE id = _id;
    END;
$$;


ALTER PROCEDURE unimia.archivia_studente(IN _motivazione unimia.tipo_motivo, IN _id uuid) OWNER TO postgres;

--
-- Name: archivia_studente_func(unimia.tipo_motivo, uuid); Type: PROCEDURE; Schema: unimia; Owner: postgres
--

CREATE PROCEDURE unimia.archivia_studente_func(IN _motivazione unimia.tipo_motivo, IN _id uuid)
    LANGUAGE plpgsql
    AS $$
    DECLARE 
        _studente studenti%ROWTYPE;
    BEGIN

    SET search_path TO unimia;

    -- salva i dati dello studente
    SELECT * INTO _studente FROM studenti WHERE id = _id;
    -- elimina lo studete
    DELETE FROM studenti WHERE id = _id;

    -- ATTENZIONE MANCA L'ARCHIVIAZIONE DEGLI ESAMI

    -- inserisce nell'archivio studenti quello appena eliminato con la motivazione personalizzata
    INSERT INTO archivio_studenti
    VALUES (_studente.id, _studente.matricola, _studente.corsodilaurea, _motivazione);

    END;
$$;


ALTER PROCEDURE unimia.archivia_studente_func(IN _motivazione unimia.tipo_motivo, IN _id uuid) OWNER TO postgres;

--
-- Name: check_anno_insegnamento(); Type: FUNCTION; Schema: unimia; Owner: postgres
--

CREATE FUNCTION unimia.check_anno_insegnamento() RETURNS trigger
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


ALTER FUNCTION unimia.check_anno_insegnamento() OWNER TO postgres;

--
-- Name: check_numeroinsegnamenti_docente(); Type: FUNCTION; Schema: unimia; Owner: postgres
--

CREATE FUNCTION unimia.check_numeroinsegnamenti_docente() RETURNS trigger
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


ALTER FUNCTION unimia.check_numeroinsegnamenti_docente() OWNER TO postgres;

--
-- Name: check_propedeuticita(); Type: FUNCTION; Schema: unimia; Owner: postgres
--

CREATE FUNCTION unimia.check_propedeuticita() RETURNS trigger
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


ALTER FUNCTION unimia.check_propedeuticita() OWNER TO postgres;

--
-- Name: controllo_iscrizione(); Type: FUNCTION; Schema: unimia; Owner: postgres
--

CREATE FUNCTION unimia.controllo_iscrizione() RETURNS trigger
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


ALTER FUNCTION unimia.controllo_iscrizione() OWNER TO postgres;

--
-- Name: correttazza_calendario_appelli(); Type: FUNCTION; Schema: unimia; Owner: postgres
--

CREATE FUNCTION unimia.correttazza_calendario_appelli() RETURNS trigger
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


ALTER FUNCTION unimia.correttazza_calendario_appelli() OWNER TO postgres;

--
-- Name: delete_appello(uuid); Type: PROCEDURE; Schema: unimia; Owner: postgres
--

CREATE PROCEDURE unimia.delete_appello(IN _id_appello uuid)
    LANGUAGE plpgsql
    AS $$
    BEGIN
        SET search_path TO unimia;

        DELETE FROM appelli WHERE id = _id_appello;

    END;
$$;


ALTER PROCEDURE unimia.delete_appello(IN _id_appello uuid) OWNER TO postgres;

--
-- Name: delete_cdl(character varying); Type: PROCEDURE; Schema: unimia; Owner: postgres
--

CREATE PROCEDURE unimia.delete_cdl(IN _id_cdl character varying)
    LANGUAGE plpgsql
    AS $$
    BEGIN    
        SET search_path TO unimia;

        DELETE FROM corsidilaurea WHERE id = _id_cdl;
    END;
$$;


ALTER PROCEDURE unimia.delete_cdl(IN _id_cdl character varying) OWNER TO postgres;

--
-- Name: delete_docente(uuid); Type: PROCEDURE; Schema: unimia; Owner: postgres
--

CREATE PROCEDURE unimia.delete_docente(IN _id uuid)
    LANGUAGE plpgsql
    AS $$
    BEGIN

      SET search_path TO unimia;

      DELETE FROM docenti
      WHERE id = _id;

      DELETE FROM utenti
      WHERE id = _id;

    END;
  $$;


ALTER PROCEDURE unimia.delete_docente(IN _id uuid) OWNER TO postgres;

--
-- Name: delete_insegnamento(character varying); Type: PROCEDURE; Schema: unimia; Owner: postgres
--

CREATE PROCEDURE unimia.delete_insegnamento(IN _id_insegnamento character varying)
    LANGUAGE plpgsql
    AS $$
    BEGIN

        SET search_path TO unimia;

        DELETE FROM insegnamenti WHERE id = _id_insegnamento;
    END;
$$;


ALTER PROCEDURE unimia.delete_insegnamento(IN _id_insegnamento character varying) OWNER TO postgres;

--
-- Name: disiscriviti_studente(uuid, uuid); Type: PROCEDURE; Schema: unimia; Owner: postgres
--

CREATE PROCEDURE unimia.disiscriviti_studente(IN _id_studente uuid, IN _id_appello uuid)
    LANGUAGE plpgsql
    AS $$
    BEGIN

    SET search_path TO unimia;

    DELETE FROM iscrizioniesami AS I WHERE I.appello = _id_appello AND I.studente = _id_studente;

    END;
$$;


ALTER PROCEDURE unimia.disiscriviti_studente(IN _id_studente uuid, IN _id_appello uuid) OWNER TO postgres;

--
-- Name: edit_password(uuid, text); Type: PROCEDURE; Schema: unimia; Owner: postgres
--

CREATE PROCEDURE unimia.edit_password(IN _id uuid, IN _newpassword text)
    LANGUAGE plpgsql
    AS $$
    BEGIN    
        SET search_path TO unimia;

        -- update password
        UPDATE utenti SET password = _newpassword
        WHERE id = _id;

        IF NOT FOUND THEN
            raise exception 'Utente non trovato'; 
        END IF;
    END;
$$;


ALTER PROCEDURE unimia.edit_password(IN _id uuid, IN _newpassword text) OWNER TO postgres;

--
-- Name: genera_matricola(); Type: FUNCTION; Schema: unimia; Owner: postgres
--

CREATE FUNCTION unimia.genera_matricola() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    DECLARE 
        _matricola char(6);
    BEGIN
        SET search_path TO unimia;

        LOOP
            _matricola := floor(random() * (999999 - 100000 + 1) + 100000)::CHAR(6);

            IF NOT EXISTS (
                SELECT matricola FROM studenti WHERE matricola = _matricola
            ) THEN
                NEW.matricola := _matricola;
                EXIT;
            END IF;
        END LOOP;

        RETURN NEW;
    END;
$$;


ALTER FUNCTION unimia.genera_matricola() OWNER TO postgres;

--
-- Name: get_all_appelli(uuid); Type: FUNCTION; Schema: unimia; Owner: postgres
--

CREATE FUNCTION unimia.get_all_appelli(_id_studente uuid) RETURNS TABLE(_id_appello uuid, _nome_insegnamento text, _nome_corso text, _nome_docente text, _data date, _orario time without time zone, _luogo text)
    LANGUAGE plpgsql
    AS $$
    DECLARE 
    BEGIN    
        SET search_path TO unimia;

        -- trovo tutti gli appelli degli insegnamenti del "mio" corso di studio 
        RETURN QUERY
        SELECT  A.id, I.nome , C.nome, CONCAT(U.nome, ' ', U.cognome) ,A.data, A.orario, A.luogo
        FROM studenti AS S
        INNER JOIN insegnamenti AS I ON I.corsodilaurea = S.corsodilaurea
        INNER JOIN appelli AS A ON A.insegnamento = I.id
        INNER JOIN corsidilaurea AS C ON C.id = I.corsodilaurea
        INNER JOIN utenti AS U ON U.id = I.docente
        WHERE S.id = _id_studente; --AND A.data > NOW();
    END;
$$;


ALTER FUNCTION unimia.get_all_appelli(_id_studente uuid) OWNER TO postgres;

--
-- Name: get_all_courses(); Type: FUNCTION; Schema: unimia; Owner: postgres
--

CREATE FUNCTION unimia.get_all_courses() RETURNS TABLE(_id character varying, _nome text, _tipo unimia.tipo_corso_laurea, _descrizione text)
    LANGUAGE plpgsql
    AS $$
    DECLARE 
    BEGIN    
        SET search_path TO unimia;

        RETURN QUERY
        SELECT C.id, C.nome, C.tipo, C.descrizione
        FROM corsidilaurea AS C 
        ORDER BY C.nome;
    END;
$$;


ALTER FUNCTION unimia.get_all_courses() OWNER TO postgres;

--
-- Name: get_all_insegnamenti(character varying); Type: FUNCTION; Schema: unimia; Owner: postgres
--

CREATE FUNCTION unimia.get_all_insegnamenti(id_corso character varying) RETURNS TABLE(_id character varying, _nome text, _descrizione text, _anno unimia.tipo_anno, _cfu smallint, _nome_docente text)
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


ALTER FUNCTION unimia.get_all_insegnamenti(id_corso character varying) OWNER TO postgres;

--
-- Name: get_all_insegnamenti_propedeutici(character varying); Type: FUNCTION; Schema: unimia; Owner: postgres
--

CREATE FUNCTION unimia.get_all_insegnamenti_propedeutici(_id_insegnamento character varying) RETURNS TABLE(_propedeutici text)
    LANGUAGE plpgsql
    AS $$
    BEGIN    
        SET search_path TO unimia;

        RETURN QUERY
        WITH RECURSIVE propedeutici AS (
            SELECT P.insegnamentopropedeutico
            FROM propedeuticita AS P
            WHERE insegnamento = _id_insegnamento
            UNION 
            SELECT P2.insegnamentopropedeutico
            FROM propedeutici AS P
            INNER JOIN propedeuticita AS P2 ON P2.insegnamentopropedeutico = P2.insegnamento
        )
        SELECT I.nome
        FROM propedeutici AS P 
        INNER JOIN insegnamenti AS I ON I.id = P.insegnamentopropedeutico;
    END;
$$;


ALTER FUNCTION unimia.get_all_insegnamenti_propedeutici(_id_insegnamento character varying) OWNER TO postgres;

--
-- Name: get_all_iscrizioni(uuid); Type: FUNCTION; Schema: unimia; Owner: postgres
--

CREATE FUNCTION unimia.get_all_iscrizioni(_id_studente uuid) RETURNS TABLE(_id_appello uuid, _nome_insegnamento text, _data date, _orario time without time zone, _luogo text)
    LANGUAGE plpgsql
    AS $$
    DECLARE 
    BEGIN    
        SET search_path TO unimia;

        -- trovo tutte le iscrizioni confermate ai miei esami
        RETURN QUERY
        SELECT A.id, I.nome, A.data, A.orario, A.luogo
        FROM iscrizioniesami AS E
        INNER JOIN appelli AS A ON A.id = E.appello
        INNER JOIN insegnamenti AS I ON I.id = A.insegnamento
        WHERE E.studente = _id_studente;
    END;
$$;


ALTER FUNCTION unimia.get_all_iscrizioni(_id_studente uuid) OWNER TO postgres;

--
-- Name: get_all_students(); Type: FUNCTION; Schema: unimia; Owner: postgres
--

CREATE FUNCTION unimia.get_all_students() RETURNS TABLE(_id uuid, _nome text, _cognome text, _email text, _matricola character, _nome_corsodilaurea text)
    LANGUAGE plpgsql
    AS $$
    DECLARE 
    BEGIN    
        SET search_path TO unimia;

        RETURN QUERY
        SELECT U.id, U.nome, U.cognome, U.email, S.matricola, C.nome
        FROM utenti AS U 
        INNER JOIN studenti AS S ON S.id = U.id
        INNER JOIN corsidilaurea AS C ON C.id = S.corsodilaurea
        ORDER BY U.cognome, U.nome;
    END;
$$;


ALTER FUNCTION unimia.get_all_students() OWNER TO postgres;

--
-- Name: get_all_teachers(); Type: FUNCTION; Schema: unimia; Owner: postgres
--

CREATE FUNCTION unimia.get_all_teachers() RETURNS TABLE(_id uuid, _nome text, _cognome text, _email text)
    LANGUAGE plpgsql
    AS $$
    DECLARE 
    BEGIN    
        SET search_path TO unimia;

        RETURN QUERY
        SELECT U.id, U.nome, U.cognome, U.email
        FROM utenti AS U 
        INNER JOIN docenti AS D ON D.id = U.id
        ORDER BY U.cognome, U.nome;
    END;
$$;


ALTER FUNCTION unimia.get_all_teachers() OWNER TO postgres;

--
-- Name: get_appelli_docente(uuid); Type: FUNCTION; Schema: unimia; Owner: postgres
--

CREATE FUNCTION unimia.get_appelli_docente(_docente uuid) RETURNS TABLE(id uuid, data date, orario time without time zone, luogo text, nome_insegnamento text, nome_corso text)
    LANGUAGE plpgsql
    AS $$
    DECLARE 
    BEGIN    
        SET search_path TO unimia;

        RETURN QUERY
        WITH insegnamenti_docente AS (
            SELECT I.id, I.nome AS nome_insegnamento, C.nome AS nome_corso
            FROM insegnamenti AS I
            INNER JOIN corsidilaurea AS C ON C.id = I.corsodilaurea
            WHERE I.docente = _docente
        )        
        SELECT A.id, A.data, A.orario, A.luogo, I.nome_insegnamento, I.nome_corso
        FROM insegnamenti_docente AS I
        INNER JOIN appelli AS A ON A.insegnamento = I.id;
    END;
$$;


ALTER FUNCTION unimia.get_appelli_docente(_docente uuid) OWNER TO postgres;

--
-- Name: get_appello(uuid); Type: FUNCTION; Schema: unimia; Owner: postgres
--

CREATE FUNCTION unimia.get_appello(_id_appello uuid) RETURNS TABLE(_id uuid, _data date, _orario time without time zone, _luogo text, _id_insegnamento character varying)
    LANGUAGE plpgsql
    AS $$
    BEGIN
    SET search_path TO unimia;

    RETURN QUERY
    SELECT A.id, A.data, A.orario, A.luogo, A.insegnamento
    FROM appelli AS A 
    WHERE A.id = _id_appello;

    END;
$$;


ALTER FUNCTION unimia.get_appello(_id_appello uuid) OWNER TO postgres;

--
-- Name: get_carriera_valida_exstudente(uuid); Type: FUNCTION; Schema: unimia; Owner: postgres
--

CREATE FUNCTION unimia.get_carriera_valida_exstudente(_studente uuid) RETURNS TABLE(_id_insegnamento character varying, _nome_insegnamento text, _data date, _voto integer)
    LANGUAGE plpgsql
    AS $$
    DECLARE 
    BEGIN    
        SET search_path TO unimia;

        RETURN QUERY
        SELECT I1.id ,I1.nome ,A1.data ,S1.voto
        FROM storicovalutazioni AS S1
        INNER JOIN appelli AS A1 ON S1.appello = A1.id
        INNER JOIN insegnamenti AS I1 ON I1.id = A1.insegnamento
        WHERE S1.studente = _studente AND (I1.id, A1.data) IN (
            SELECT I2.id, MAX(A2.data)
            FROM storicovalutazioni AS S2
            INNER JOIN appelli AS A2 ON S2.appello = A2.id
            INNER JOIN insegnamenti AS I2 ON I2.id = A2.insegnamento
            WHERE S2.studente = _studente
            GROUP BY I2.id
        )AND S1.voto >= 18;

    END;
$$;


ALTER FUNCTION unimia.get_carriera_valida_exstudente(_studente uuid) OWNER TO postgres;

--
-- Name: get_carriera_valida_studente(uuid); Type: FUNCTION; Schema: unimia; Owner: postgres
--

CREATE FUNCTION unimia.get_carriera_valida_studente(_studente uuid) RETURNS TABLE(_id_insegnamento character varying, _nome_insegnamento text, _data date, _voto integer)
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


ALTER FUNCTION unimia.get_carriera_valida_studente(_studente uuid) OWNER TO postgres;

--
-- Name: get_cdl(character varying); Type: FUNCTION; Schema: unimia; Owner: postgres
--

CREATE FUNCTION unimia.get_cdl(_id_corso character varying) RETURNS TABLE(_id character varying, _nome text, _tipo unimia.tipo_corso_laurea, _descrizione text)
    LANGUAGE plpgsql
    AS $$
    BEGIN

    SET search_path TO unimia;

    RETURN QUERY
    SELECT C.id, C.nome, C.tipo, C.descrizione
    FROM corsidilaurea AS C 
    WHERE C.id = _id_corso;

    END;
$$;


ALTER FUNCTION unimia.get_cdl(_id_corso character varying) OWNER TO postgres;

--
-- Name: get_esami_valutare_docente(uuid); Type: FUNCTION; Schema: unimia; Owner: postgres
--

CREATE FUNCTION unimia.get_esami_valutare_docente(_docente uuid) RETURNS TABLE(_appello uuid, _nome_insegnamento text, _data date, _studente uuid, _matricola character, _nome text)
    LANGUAGE plpgsql
    AS $$
    DECLARE 
    BEGIN    
        SET search_path TO unimia;

        -- trovo tutti gli esami che il docente possa
        RETURN QUERY
        SELECT A.id, I.nome, A.data, U.id, S.matricola, CONCAT(U.nome, ' ', U.cognome) 
        FROM iscrizioniesami AS ISC 
        INNER JOIN utenti AS U ON U.id = ISC.studente
        INNER JOIN studenti AS S ON S.id = U.id
        INNER JOIN appelli AS A ON A.id = ISC.appello
        INNER JOIN insegnamenti AS I ON I.id = A.insegnamento
        WHERE I.docente = _docente AND NOW() > A.data -- l'appello deve essere nel "passato"
        EXCEPT -- tolgo da valutare esami gia' valutati
        SELECT A2.id, I2.nome, A2.data, U2.id, S2.matricola, CONCAT(U2.nome, ' ', U2.cognome) 
        FROM esitiesami AS E
        INNER JOIN utenti AS U2 ON U2.id = E.studente
        INNER JOIN studenti AS S2 ON S2.id = U2.id
        INNER JOIN appelli AS A2 ON A2.id = E.appello
        INNER JOIN insegnamenti AS I2 ON I2.id = A2.insegnamento
        WHERE I2.docente = _docente;
    END;
$$;


ALTER FUNCTION unimia.get_esami_valutare_docente(_docente uuid) OWNER TO postgres;

--
-- Name: get_insegnamenti_docente(uuid); Type: FUNCTION; Schema: unimia; Owner: postgres
--

CREATE FUNCTION unimia.get_insegnamenti_docente(_docente uuid) RETURNS TABLE(_id character varying, _nome text, _descrizione text, _anno unimia.tipo_anno, _cfu smallint, _nome_corsodilaurea text)
    LANGUAGE plpgsql
    AS $$
    DECLARE 
    BEGIN    
        SET search_path TO unimia;

        RETURN QUERY
        SELECT I.id, I.nome, I.descrizione, I.anno, I.cfu, C.nome
        FROM insegnamenti AS I
        INNER JOIN corsidilaurea AS C ON C.id = I.corsodilaurea
        WHERE I.docente = _docente;
    END;
$$;


ALTER FUNCTION unimia.get_insegnamenti_docente(_docente uuid) OWNER TO postgres;

--
-- Name: get_insegnamento(character varying); Type: FUNCTION; Schema: unimia; Owner: postgres
--

CREATE FUNCTION unimia.get_insegnamento(_id_insegnamento character varying) RETURNS TABLE(_id character varying, _nome text, _descrizione text, _anno unimia.tipo_anno, _cfu smallint, _corso_di_laurea character varying, _docente uuid)
    LANGUAGE plpgsql
    AS $$
    BEGIN
    SET search_path TO unimia;

    RETURN QUERY
    SELECT I.id, I.nome, I.descrizione, I.anno, I.cfu, I.corsodilaurea, I.docente
    FROM insegnamenti AS I 
    WHERE I.id = _id_insegnamento;

    END;
$$;


ALTER FUNCTION unimia.get_insegnamento(_id_insegnamento character varying) OWNER TO postgres;

--
-- Name: get_student(uuid); Type: FUNCTION; Schema: unimia; Owner: postgres
--

CREATE FUNCTION unimia.get_student(_id_studente uuid) RETURNS TABLE(_id uuid, _nome text, _cognome text, _email text, _matricola character, _corso character varying)
    LANGUAGE plpgsql
    AS $$
    DECLARE 
    BEGIN    
        SET search_path TO unimia;

        RETURN QUERY
        SELECT U.id, U.nome, U.cognome, U.email, S.matricola, C.id
        FROM utenti AS U 
        INNER JOIN studenti AS S ON S.id = U.id
        INNER JOIN corsidilaurea AS C ON C.id = S.corsodilaurea
        WHERE U.id = _id_studente;
    END;
$$;


ALTER FUNCTION unimia.get_student(_id_studente uuid) OWNER TO postgres;

--
-- Name: get_teacher(uuid); Type: FUNCTION; Schema: unimia; Owner: postgres
--

CREATE FUNCTION unimia.get_teacher(_id_teacher uuid) RETURNS TABLE(_id uuid, _nome text, _cognome text, _email text)
    LANGUAGE plpgsql
    AS $$
    BEGIN

    SET search_path TO unimia;

    RETURN QUERY
    SELECT U.id, U.nome, U.cognome, U.email
    FROM docenti AS D
    INNER JOIN utenti AS U ON U.id = D.id
    WHERE U.id = _id_teacher;

    END;
$$;


ALTER FUNCTION unimia.get_teacher(_id_teacher uuid) OWNER TO postgres;

--
-- Name: get_voti_exstudente(uuid); Type: FUNCTION; Schema: unimia; Owner: postgres
--

CREATE FUNCTION unimia.get_voti_exstudente(_studente uuid) RETURNS TABLE(_id_insegnamento character varying, _nome_insegnamento text, _data date, _voto integer)
    LANGUAGE plpgsql
    AS $$
    DECLARE 
    BEGIN    
        SET search_path TO unimia;

        RETURN QUERY
        SELECT I.id, I.nome, A.data, V.voto
        FROM storicovalutazioni AS V
        INNER JOIN appelli AS A ON A.id = V.appello
        INNER JOIN insegnamenti AS I ON I.id = A.insegnamento
        WHERE V.studente = _studente;
    END;
$$;


ALTER FUNCTION unimia.get_voti_exstudente(_studente uuid) OWNER TO postgres;

--
-- Name: get_voti_studente(uuid); Type: FUNCTION; Schema: unimia; Owner: postgres
--

CREATE FUNCTION unimia.get_voti_studente(_studente uuid) RETURNS TABLE(_id_insegnamento character varying, _nome_insegnamento text, _data date, _voto integer)
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


ALTER FUNCTION unimia.get_voti_studente(_studente uuid) OWNER TO postgres;

--
-- Name: update_appello(uuid, date, time without time zone, text, character varying); Type: PROCEDURE; Schema: unimia; Owner: postgres
--

CREATE PROCEDURE unimia.update_appello(IN _id uuid, IN _data date, IN _orario time without time zone, IN _luogo text, IN _insegnamento character varying)
    LANGUAGE plpgsql
    AS $$
    DECLARE _old DATE;
    BEGIN
        SET search_path TO unimia;

        SELECT data INTO _old FROM appelli WHERE id = _id;

        -- se faccio un update su una data passata
        IF NOW() > _old THEN
            raise exception 'Appello passato, non può essere modificato';
        END IF;

        -- se la data che sto per mettere e' nel passato
        IF NOW() > _data THEN
            raise exception 'Appello non deve essere nel passato';
        END IF;

        UPDATE appelli SET
            data = _data,
            orario = _orario,
            luogo = _luogo
        WHERE id = _id;

    END;
$$;


ALTER PROCEDURE unimia.update_appello(IN _id uuid, IN _data date, IN _orario time without time zone, IN _luogo text, IN _insegnamento character varying) OWNER TO postgres;

--
-- Name: update_cdl(character varying, text, unimia.tipo_corso_laurea, text); Type: PROCEDURE; Schema: unimia; Owner: postgres
--

CREATE PROCEDURE unimia.update_cdl(IN _id character varying, IN _nome text, IN _tipo unimia.tipo_corso_laurea, IN _descrizione text)
    LANGUAGE plpgsql
    AS $$
    BEGIN

        SET search_path TO unimia;

        UPDATE corsidilaurea SET
            nome = _nome,
            tipo = _tipo, 
            descrizione = _descrizione
        WHERE id = _id;

    END;
$$;


ALTER PROCEDURE unimia.update_cdl(IN _id character varying, IN _nome text, IN _tipo unimia.tipo_corso_laurea, IN _descrizione text) OWNER TO postgres;

--
-- Name: update_insegnamento(character varying, text, text, unimia.tipo_anno, smallint, character varying, uuid); Type: PROCEDURE; Schema: unimia; Owner: postgres
--

CREATE PROCEDURE unimia.update_insegnamento(IN _id character varying, IN _nome text, IN _descrizione text, IN _anno unimia.tipo_anno, IN _cfu smallint, IN _corso character varying, IN _docente uuid)
    LANGUAGE plpgsql
    AS $$
    BEGIN
        SET search_path TO unimia;

        UPDATE insegnamenti SET
            id = _id, 
            corsodilaurea = _corso,
            nome = _nome,
            descrizione = _descrizione, 
            cfu = _cfu,
            anno = _anno,
            docente = _docente
        WHERE id = _id;
    END;
$$;


ALTER PROCEDURE unimia.update_insegnamento(IN _id character varying, IN _nome text, IN _descrizione text, IN _anno unimia.tipo_anno, IN _cfu smallint, IN _corso character varying, IN _docente uuid) OWNER TO postgres;

--
-- Name: update_student(uuid, text, text, text, character, character varying); Type: PROCEDURE; Schema: unimia; Owner: postgres
--

CREATE PROCEDURE unimia.update_student(IN _id uuid, IN _nome text, IN _cognome text, IN _email text, IN _matricola character, IN _corso_di_laurea character varying)
    LANGUAGE plpgsql
    AS $$
    BEGIN

    SET search_path TO unimia;

    -- modifico le informaazioni quali nome cognome ed email
    UPDATE utenti SET
        nome = _nome,
        cognome = _cognome,
        email = _email
    WHERE id = _id;

    -- modifico la matricola e il cdl
    UPDATE studenti SET
        matricola = _matricola,
        corsodilaurea = _corso_di_laurea
    WHERE id = _id;

    END;
$$;


ALTER PROCEDURE unimia.update_student(IN _id uuid, IN _nome text, IN _cognome text, IN _email text, IN _matricola character, IN _corso_di_laurea character varying) OWNER TO postgres;

--
-- Name: update_teacher(uuid, text, text, text); Type: PROCEDURE; Schema: unimia; Owner: postgres
--

CREATE PROCEDURE unimia.update_teacher(IN _id uuid, IN _nome text, IN _cognome text, IN _email text)
    LANGUAGE plpgsql
    AS $$
    BEGIN

        SET search_path TO unimia;

        UPDATE utenti SET
        nome = _nome,
        cognome = _cognome, 
        email = _email
        WHERE id = _id;

    END;
$$;


ALTER PROCEDURE unimia.update_teacher(IN _id uuid, IN _nome text, IN _cognome text, IN _email text) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: appelli; Type: TABLE; Schema: unimia; Owner: postgres
--

CREATE TABLE unimia.appelli (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    data date NOT NULL,
    orario time without time zone NOT NULL,
    luogo text NOT NULL,
    insegnamento character varying(6) NOT NULL
);


ALTER TABLE unimia.appelli OWNER TO postgres;

--
-- Name: corsidilaurea; Type: TABLE; Schema: unimia; Owner: postgres
--

CREATE TABLE unimia.corsidilaurea (
    id character varying(6) NOT NULL,
    nome text NOT NULL,
    tipo unimia.tipo_corso_laurea NOT NULL,
    descrizione text NOT NULL
);


ALTER TABLE unimia.corsidilaurea OWNER TO postgres;

--
-- Name: docenti; Type: TABLE; Schema: unimia; Owner: postgres
--

CREATE TABLE unimia.docenti (
    id uuid NOT NULL
);


ALTER TABLE unimia.docenti OWNER TO postgres;

--
-- Name: esitiesami; Type: TABLE; Schema: unimia; Owner: postgres
--

CREATE TABLE unimia.esitiesami (
    studente uuid NOT NULL,
    appello uuid NOT NULL,
    voto integer,
    CONSTRAINT esitiesami_voto_check CHECK (((voto >= 0) AND (voto <= 31)))
);


ALTER TABLE unimia.esitiesami OWNER TO postgres;

--
-- Name: insegnamenti; Type: TABLE; Schema: unimia; Owner: postgres
--

CREATE TABLE unimia.insegnamenti (
    id character varying(6) NOT NULL,
    nome text NOT NULL,
    descrizione text NOT NULL,
    anno unimia.tipo_anno NOT NULL,
    cfu smallint NOT NULL,
    corsodilaurea character varying(6) NOT NULL,
    docente uuid NOT NULL,
    CONSTRAINT insegnamenti_cfu_check CHECK (((cfu > 0) AND (cfu <= 15)))
);


ALTER TABLE unimia.insegnamenti OWNER TO postgres;

--
-- Name: iscrizioniesami; Type: TABLE; Schema: unimia; Owner: postgres
--

CREATE TABLE unimia.iscrizioniesami (
    studente uuid NOT NULL,
    appello uuid NOT NULL
);


ALTER TABLE unimia.iscrizioniesami OWNER TO postgres;

--
-- Name: propedeuticita; Type: TABLE; Schema: unimia; Owner: postgres
--

CREATE TABLE unimia.propedeuticita (
    insegnamento character(6) NOT NULL,
    insegnamentopropedeutico character(6) NOT NULL
);


ALTER TABLE unimia.propedeuticita OWNER TO postgres;

--
-- Name: segreteria; Type: TABLE; Schema: unimia; Owner: postgres
--

CREATE TABLE unimia.segreteria (
    id uuid NOT NULL
);


ALTER TABLE unimia.segreteria OWNER TO postgres;

--
-- Name: storicoiscrizioni; Type: TABLE; Schema: unimia; Owner: postgres
--

CREATE TABLE unimia.storicoiscrizioni (
    studente uuid NOT NULL,
    appello uuid NOT NULL
);


ALTER TABLE unimia.storicoiscrizioni OWNER TO postgres;

--
-- Name: storicostudenti; Type: TABLE; Schema: unimia; Owner: postgres
--

CREATE TABLE unimia.storicostudenti (
    id uuid NOT NULL,
    matricola character(6) NOT NULL,
    motivo unimia.tipo_motivo NOT NULL,
    corsodilaurea character(6) NOT NULL
);


ALTER TABLE unimia.storicostudenti OWNER TO postgres;

--
-- Name: storicovalutazioni; Type: TABLE; Schema: unimia; Owner: postgres
--

CREATE TABLE unimia.storicovalutazioni (
    studente uuid NOT NULL,
    appello uuid NOT NULL,
    voto integer,
    CONSTRAINT storicovalutazioni_voto_check CHECK (((voto >= 0) AND (voto <= 31)))
);


ALTER TABLE unimia.storicovalutazioni OWNER TO postgres;

--
-- Name: studenti; Type: TABLE; Schema: unimia; Owner: postgres
--

CREATE TABLE unimia.studenti (
    id uuid NOT NULL,
    matricola character(6) NOT NULL,
    corsodilaurea character(6) NOT NULL,
    CONSTRAINT studenti_matricola_check CHECK ((matricola ~* '^\d{6}$'::text))
);


ALTER TABLE unimia.studenti OWNER TO postgres;

--
-- Name: utenti; Type: TABLE; Schema: unimia; Owner: postgres
--

CREATE TABLE unimia.utenti (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    email text NOT NULL,
    password text NOT NULL,
    tipo unimia.tipo_utenti NOT NULL,
    nome text NOT NULL,
    cognome text NOT NULL,
    CONSTRAINT utenti_cognome_check CHECK ((cognome ~* '^.+$'::text)),
    CONSTRAINT utenti_email_check CHECK ((email ~* '^[A-Za-z0-9._%-]+@studente|docente|segreteria.it$'::text)),
    CONSTRAINT utenti_nome_check CHECK ((nome ~* '^.+$'::text)),
    CONSTRAINT utenti_password_check CHECK ((length(password) > 3))
);


ALTER TABLE unimia.utenti OWNER TO postgres;

--
-- Data for Name: appelli; Type: TABLE DATA; Schema: unimia; Owner: postgres
--

COPY unimia.appelli (id, data, orario, luogo, insegnamento) FROM stdin;
2a637164-c600-4c45-a878-9792977a3348	2024-02-16	15:45:00	Via gialli, 3	436719
122c570b-bbe9-4c64-89a8-d26be718f139	2024-02-13	14:00:00	Via gialli, 5	436719
23ae8c60-0174-47c4-bc24-890d6338182f	2024-01-19	14:00:00	Via verdi 17	436719
decb019d-0312-4cf3-9452-43d175e4fa2e	2024-02-21	14:00:00	Via robertoni, 3	647781
319b3917-425c-44a5-9213-76d14dd05178	2024-03-02	15:35:00	Via rossi, 12	647781
0c3f620b-a43b-495a-a2a6-19c072a63adf	2024-07-01	09:00:00	Via calattafimi 24	234278
4c6db445-bceb-40ad-8d6e-f3223b0d2bef	2024-03-23	14:00:00	Via gialli, 8	458291
803daf2f-89cd-48ce-b490-6a7617f3881c	2024-01-21	14:00:00	Via gialli, 5	758192
2af949d6-e807-4435-80e4-7d0a7fef2611	2024-02-10	08:30:00	Via verdi 17	758192
2af952a8-8c11-48de-a04f-c7cdcd561c00	2024-01-11	08:30:00	Via verdi 21	364912
12f89d12-14a5-4dee-a5b7-c1c4e0fcbe1b	2024-02-12	14:00:00	Via verdi 17	364912
01900c90-1444-4d04-9aa6-4f104bdfd457	2024-02-01	08:30:00	Via ferro 3	348729
be111705-adab-47c2-9e9b-e814d15c0c41	2024-01-10	14:00:00	Via verdone 17	348729
4ee323f6-cfa3-42c1-93c1-20169ee79e8b	2024-02-03	14:20:00	Via Nero 2	312189
bbc744bc-9eb7-4506-9cff-48c0280a008d	2024-01-23	11:00:00	Via gialli, 12	312189
d768931e-f83f-4453-9e80-479a180ac68a	2024-01-14	14:00:00	Via verdi 24	891723
f1d76b44-c9c6-4804-8431-e022341a253f	2024-02-14	17:00:00	Via sole 1	891723
37a52fc3-2085-485a-9cc1-b98f3e54062a	2024-02-08	14:00:00	Via gialli, 5	273618
4bfe50b1-c5d3-4204-8f5c-f8143a11d286	2024-04-22	19:00:00	Via verdi	436719
6ef69cf4-ddf7-49da-91ad-a754654dd4ce	2024-03-21	08:30:00	Via giallo 1	129813
\.


--
-- Data for Name: corsidilaurea; Type: TABLE DATA; Schema: unimia; Owner: postgres
--

COPY unimia.corsidilaurea (id, nome, tipo, descrizione) FROM stdin;
034312	informatica	triennale	corso sui computer
098214	ai	magistrale	corso sulla inteligenza artificiale
874124	biochimica	magistrale a ciclo unico	corso sulle piante
981232	assistenza sanitaria	triennale	corso per infermiere
784512	chimica	magistrale a ciclo unico	corso per i chimici
875371	fisioterapia	magistrale	per far star bene i muscoli
561281	matematica	magistrale	corso per i matematici ed analisti
238171	medicina	triennale	per diventare dottori e altro
128911	storia	magistrale a ciclo unico	corso per gli storici
453827	Fisica	magistrale a ciclo unico	viva la fisica
671821	Scienze geologiche ambientali	magistrale	corso sulla terra e molto altro forse
\.


--
-- Data for Name: docenti; Type: TABLE DATA; Schema: unimia; Owner: postgres
--

COPY unimia.docenti (id) FROM stdin;
e4910308-f130-4373-a495-d37b75cb38e0
84bf9cda-3bc2-4d6b-937c-00a2e1924a08
f18d6bed-7022-430b-a549-aa8a7b763d27
34598c3d-4816-4d6f-9a88-bb28bb1dad4e
a14ec76a-b303-4d11-9ef3-caf4d3ed7c42
29c49454-baa5-4559-ae94-7aadf1ac4d69
5eba1860-8120-4ea3-916a-6095c3645e47
\.


--
-- Data for Name: esitiesami; Type: TABLE DATA; Schema: unimia; Owner: postgres
--

COPY unimia.esitiesami (studente, appello, voto) FROM stdin;
bb684dc1-a9cf-42a6-8bbc-55d569b41c92	2a637164-c600-4c45-a878-9792977a3348	18
ceb05c23-4ca8-4887-aef1-88db6043ebf1	23ae8c60-0174-47c4-bc24-890d6338182f	23
66e0421f-c20f-44f8-9c44-127b0ccdbc74	803daf2f-89cd-48ce-b490-6a7617f3881c	27
66e0421f-c20f-44f8-9c44-127b0ccdbc74	2af952a8-8c11-48de-a04f-c7cdcd561c00	14
66e0421f-c20f-44f8-9c44-127b0ccdbc74	12f89d12-14a5-4dee-a5b7-c1c4e0fcbe1b	21
66e0421f-c20f-44f8-9c44-127b0ccdbc74	2af949d6-e807-4435-80e4-7d0a7fef2611	28
66e0421f-c20f-44f8-9c44-127b0ccdbc74	01900c90-1444-4d04-9aa6-4f104bdfd457	12
66e0421f-c20f-44f8-9c44-127b0ccdbc74	f1d76b44-c9c6-4804-8431-e022341a253f	12
66e0421f-c20f-44f8-9c44-127b0ccdbc74	d768931e-f83f-4453-9e80-479a180ac68a	21
66e0421f-c20f-44f8-9c44-127b0ccdbc74	37a52fc3-2085-485a-9cc1-b98f3e54062a	18
706b272c-0979-4289-8845-21f777a6b18b	2af949d6-e807-4435-80e4-7d0a7fef2611	23
706b272c-0979-4289-8845-21f777a6b18b	803daf2f-89cd-48ce-b490-6a7617f3881c	27
\.


--
-- Data for Name: insegnamenti; Type: TABLE DATA; Schema: unimia; Owner: postgres
--

COPY unimia.insegnamenti (id, nome, descrizione, anno, cfu, corsodilaurea, docente) FROM stdin;
231562	basi di dati	per capire i db	2	12	034312	f18d6bed-7022-430b-a549-aa8a7b763d27
129813	algoritmi	strutture dati	2	12	034312	84bf9cda-3bc2-4d6b-937c-00a2e1924a08
758192	programmazione 1	per iniziare	1	12	034312	84bf9cda-3bc2-4d6b-937c-00a2e1924a08
364912	programmazione 2	oop oggetti evviva	2	6	034312	84bf9cda-3bc2-4d6b-937c-00a2e1924a08
562418	reti	reti web	3	12	034312	f18d6bed-7022-430b-a549-aa8a7b763d27
671821	sweng	corso ciclo di vita del sw	1	3	034312	34598c3d-4816-4d6f-9a88-bb28bb1dad4e
726181	basi di dati 2	corso per db	3	15	034312	34598c3d-4816-4d6f-9a88-bb28bb1dad4e
436719	Fisica medica	Le basi del metodo scientifico,	1	3	238171	e4910308-f130-4373-a495-d37b75cb38e0
647781	Anatomia umana	struttura del corpo umano e degli apparati, sistemi e organi che lo costituiscono	2	12	238171	e4910308-f130-4373-a495-d37b75cb38e0
234278	Astrofisica	Per gli amanti degli astri	4	12	453827	a14ec76a-b303-4d11-9ef3-caf4d3ed7c42
458291	Fisica 1	corso generale di fisica	3	15	453827	a14ec76a-b303-4d11-9ef3-caf4d3ed7c42
348729	Archi 1	architettura degli elaboratori	1	6	034312	a14ec76a-b303-4d11-9ef3-caf4d3ed7c42
312189	Archi 2	architettura degli elaboratori 2	2	6	034312	f18d6bed-7022-430b-a549-aa8a7b763d27
273618	matematica del discreto	matrici vettori etc...	2	9	034312	29c49454-baa5-4559-ae94-7aadf1ac4d69
425617	Istologia ed embriologia 2	conoscenza degli stadi iniziali dello sviluppo dell'organismo 2	2	3	238171	e4910308-f130-4373-a495-d37b75cb38e0
891723	Programmazione funzionale	impara f# e twelf 	3	6	453827	29c49454-baa5-4559-ae94-7aadf1ac4d69
\.


--
-- Data for Name: iscrizioniesami; Type: TABLE DATA; Schema: unimia; Owner: postgres
--

COPY unimia.iscrizioniesami (studente, appello) FROM stdin;
bb684dc1-a9cf-42a6-8bbc-55d569b41c92	2a637164-c600-4c45-a878-9792977a3348
bb684dc1-a9cf-42a6-8bbc-55d569b41c92	319b3917-425c-44a5-9213-76d14dd05178
d42bfbbd-d916-4aa1-9c41-9d32d142d76e	0c3f620b-a43b-495a-a2a6-19c072a63adf
66e0421f-c20f-44f8-9c44-127b0ccdbc74	803daf2f-89cd-48ce-b490-6a7617f3881c
66e0421f-c20f-44f8-9c44-127b0ccdbc74	2af952a8-8c11-48de-a04f-c7cdcd561c00
66e0421f-c20f-44f8-9c44-127b0ccdbc74	6ef69cf4-ddf7-49da-91ad-a754654dd4ce
66e0421f-c20f-44f8-9c44-127b0ccdbc74	12f89d12-14a5-4dee-a5b7-c1c4e0fcbe1b
66e0421f-c20f-44f8-9c44-127b0ccdbc74	2af949d6-e807-4435-80e4-7d0a7fef2611
66e0421f-c20f-44f8-9c44-127b0ccdbc74	01900c90-1444-4d04-9aa6-4f104bdfd457
66e0421f-c20f-44f8-9c44-127b0ccdbc74	d768931e-f83f-4453-9e80-479a180ac68a
66e0421f-c20f-44f8-9c44-127b0ccdbc74	f1d76b44-c9c6-4804-8431-e022341a253f
66e0421f-c20f-44f8-9c44-127b0ccdbc74	37a52fc3-2085-485a-9cc1-b98f3e54062a
706b272c-0979-4289-8845-21f777a6b18b	803daf2f-89cd-48ce-b490-6a7617f3881c
706b272c-0979-4289-8845-21f777a6b18b	6ef69cf4-ddf7-49da-91ad-a754654dd4ce
706b272c-0979-4289-8845-21f777a6b18b	2af949d6-e807-4435-80e4-7d0a7fef2611
\.


--
-- Data for Name: propedeuticita; Type: TABLE DATA; Schema: unimia; Owner: postgres
--

COPY unimia.propedeuticita (insegnamento, insegnamentopropedeutico) FROM stdin;
364912	758192
562418	758192
562418	231562
726181	231562
726181	758192
458291	234278
312189	348729
\.


--
-- Data for Name: segreteria; Type: TABLE DATA; Schema: unimia; Owner: postgres
--

COPY unimia.segreteria (id) FROM stdin;
74199924-8430-4159-b572-0f5fadecd69c
7e3063ef-b523-4b01-b03f-94df491959fd
a6893b8b-5634-488d-9afa-adfda922781d
\.


--
-- Data for Name: storicoiscrizioni; Type: TABLE DATA; Schema: unimia; Owner: postgres
--

COPY unimia.storicoiscrizioni (studente, appello) FROM stdin;
4bf49ea3-a99f-45a2-b57f-665f31401287	23ae8c60-0174-47c4-bc24-890d6338182f
4bf49ea3-a99f-45a2-b57f-665f31401287	122c570b-bbe9-4c64-89a8-d26be718f139
4bf49ea3-a99f-45a2-b57f-665f31401287	decb019d-0312-4cf3-9452-43d175e4fa2e
\.


--
-- Data for Name: storicostudenti; Type: TABLE DATA; Schema: unimia; Owner: postgres
--

COPY unimia.storicostudenti (id, matricola, motivo, corsodilaurea) FROM stdin;
f26ae182-7845-49d3-81ae-7dc11098c667	759901	rinuncia	034312
c5b608ff-3162-4229-974b-0caece72f9dc	491769	laurea	034312
5aacade4-77a6-4566-a542-ae7206a19ead	854427	rinuncia	875371
4bf49ea3-a99f-45a2-b57f-665f31401287	640588	rinuncia	238171
\.


--
-- Data for Name: storicovalutazioni; Type: TABLE DATA; Schema: unimia; Owner: postgres
--

COPY unimia.storicovalutazioni (studente, appello, voto) FROM stdin;
4bf49ea3-a99f-45a2-b57f-665f31401287	122c570b-bbe9-4c64-89a8-d26be718f139	25
4bf49ea3-a99f-45a2-b57f-665f31401287	23ae8c60-0174-47c4-bc24-890d6338182f	19
\.


--
-- Data for Name: studenti; Type: TABLE DATA; Schema: unimia; Owner: postgres
--

COPY unimia.studenti (id, matricola, corsodilaurea) FROM stdin;
706b272c-0979-4289-8845-21f777a6b18b	975112	034312
28cabd37-6090-4640-84b7-14995c17a45b	975232	098214
df05c07c-2afa-4291-8bc1-3d060c63343d	912112	784512
eb7804f3-8e4f-456c-9370-1b07e4d85af0	884629	784512
8241e044-9e29-464a-a34f-841344e04f1d	908548	981232
3f1648cb-f2b6-475d-9ea2-597ddfa20180	276221	875371
66e0421f-c20f-44f8-9c44-127b0ccdbc74	252209	034312
bb684dc1-a9cf-42a6-8bbc-55d569b41c92	362549	238171
d42bfbbd-d916-4aa1-9c41-9d32d142d76e	158791	453827
b200b1f4-c6b6-4aed-86a4-7bd9be979f78	609631	875371
ceb05c23-4ca8-4887-aef1-88db6043ebf1	576440	561281
\.


--
-- Data for Name: utenti; Type: TABLE DATA; Schema: unimia; Owner: postgres
--

COPY unimia.utenti (id, email, password, tipo, nome, cognome) FROM stdin;
28cabd37-6090-4640-84b7-14995c17a45b	mario@studente.it	ciaobella	studente	Mario	Rossi
84bf9cda-3bc2-4d6b-937c-00a2e1924a08	pino@docente.it	pinotto	docente	Pino	Rossi
f18d6bed-7022-430b-a549-aa8a7b763d27	laura@docente.it	laura	docente	Laura	Boni
74199924-8430-4159-b572-0f5fadecd69c	mario@segreteria.it	mario	segretario	Mario	Rossi
a6893b8b-5634-488d-9afa-adfda922781d	gaia@segreteria.it	password	segretario	Gaia	Gialli
eb7804f3-8e4f-456c-9370-1b07e4d85af0	gianfranco@studente.it	gianni	studente	Gianfranco	Gialli
706b272c-0979-4289-8845-21f777a6b18b	gabry@studente.it	nuovapassword	studente	Gabriele	Sarti
8241e044-9e29-464a-a34f-841344e04f1d	franco@studente.it	wewew	studente	Franco	Nero
3f1648cb-f2b6-475d-9ea2-597ddfa20180	alfredodangelo@studente.it	alfredo	studente	alfredo	dangelo
5aacade4-77a6-4566-a542-ae7206a19ead	barba@studente.it	barba	studente	Barba	scura
c5b608ff-3162-4229-974b-0caece72f9dc	carmela@studente.it	carmela	studente	Carmela	Sofia
66e0421f-c20f-44f8-9c44-127b0ccdbc74	matteorossi@studente.it	pippo	studente	matteo	rossi
f26ae182-7845-49d3-81ae-7dc11098c667	pippopluto@studente.it	pippo	studente	Pippo	Pluto
34598c3d-4816-4d6f-9a88-bb28bb1dad4e	mariorossi@docente.it	sonomario	docente	Mario	Rossi
bb684dc1-a9cf-42a6-8bbc-55d569b41c92	giacomorossi@studente.it	giacomo	studente	giacomo	rossi
a14ec76a-b303-4d11-9ef3-caf4d3ed7c42	paolarossa@docente.it	paros	docente	Paola	Rossa
d42bfbbd-d916-4aa1-9c41-9d32d142d76e	alessiorossi@studente.it	ciao	studente	alessio	rossi
29c49454-baa5-4559-ae94-7aadf1ac4d69	docente1@docente.it	docente1	docente	Docente	1
5eba1860-8120-4ea3-916a-6095c3645e47	docente2@docente.it	docente2	docente	Docente	2
4bf49ea3-a99f-45a2-b57f-665f31401287	pippo2@studente.it	pippone	ex_studente	Pippo	Sosia
b200b1f4-c6b6-4aed-86a4-7bd9be979f78	giovanni22@studente.unimi.it	giova	studente	Gio	Sarti
ceb05c23-4ca8-4887-aef1-88db6043ebf1	rapunzel@studente.it	rapunzel	studente	Rapunzel	Socia
df05c07c-2afa-4291-8bc1-3d060c63343d	rosa@studente.it	ciaorosa2	studente	Rosa	Verdi
e4910308-f130-4373-a495-d37b75cb38e0	fernandi@docente.it	fernanda	docente	Ferna	Nero
7e3063ef-b523-4b01-b03f-94df491959fd	alessiorossi32@studente.it	calcio2	segretario	alessio	rossi
\.


--
-- Name: appelli appelli_pkey; Type: CONSTRAINT; Schema: unimia; Owner: postgres
--

ALTER TABLE ONLY unimia.appelli
    ADD CONSTRAINT appelli_pkey PRIMARY KEY (id);


--
-- Name: corsidilaurea corsidilaurea_pkey; Type: CONSTRAINT; Schema: unimia; Owner: postgres
--

ALTER TABLE ONLY unimia.corsidilaurea
    ADD CONSTRAINT corsidilaurea_pkey PRIMARY KEY (id);


--
-- Name: docenti docenti_pkey; Type: CONSTRAINT; Schema: unimia; Owner: postgres
--

ALTER TABLE ONLY unimia.docenti
    ADD CONSTRAINT docenti_pkey PRIMARY KEY (id);


--
-- Name: esitiesami esitiesami_pkey; Type: CONSTRAINT; Schema: unimia; Owner: postgres
--

ALTER TABLE ONLY unimia.esitiesami
    ADD CONSTRAINT esitiesami_pkey PRIMARY KEY (appello, studente);


--
-- Name: insegnamenti insegnamenti_pkey; Type: CONSTRAINT; Schema: unimia; Owner: postgres
--

ALTER TABLE ONLY unimia.insegnamenti
    ADD CONSTRAINT insegnamenti_pkey PRIMARY KEY (id);


--
-- Name: iscrizioniesami iscrizioniesami_pkey; Type: CONSTRAINT; Schema: unimia; Owner: postgres
--

ALTER TABLE ONLY unimia.iscrizioniesami
    ADD CONSTRAINT iscrizioniesami_pkey PRIMARY KEY (appello, studente);


--
-- Name: propedeuticita propedeuticita_pkey; Type: CONSTRAINT; Schema: unimia; Owner: postgres
--

ALTER TABLE ONLY unimia.propedeuticita
    ADD CONSTRAINT propedeuticita_pkey PRIMARY KEY (insegnamento, insegnamentopropedeutico);


--
-- Name: segreteria segreteria_pkey; Type: CONSTRAINT; Schema: unimia; Owner: postgres
--

ALTER TABLE ONLY unimia.segreteria
    ADD CONSTRAINT segreteria_pkey PRIMARY KEY (id);


--
-- Name: storicoiscrizioni storicoiscrizioni_pkey; Type: CONSTRAINT; Schema: unimia; Owner: postgres
--

ALTER TABLE ONLY unimia.storicoiscrizioni
    ADD CONSTRAINT storicoiscrizioni_pkey PRIMARY KEY (appello, studente);


--
-- Name: storicostudenti storicostudenti_matricola_key; Type: CONSTRAINT; Schema: unimia; Owner: postgres
--

ALTER TABLE ONLY unimia.storicostudenti
    ADD CONSTRAINT storicostudenti_matricola_key UNIQUE (matricola);


--
-- Name: storicostudenti storicostudenti_pkey; Type: CONSTRAINT; Schema: unimia; Owner: postgres
--

ALTER TABLE ONLY unimia.storicostudenti
    ADD CONSTRAINT storicostudenti_pkey PRIMARY KEY (id);


--
-- Name: storicovalutazioni storicovalutazioni_pkey; Type: CONSTRAINT; Schema: unimia; Owner: postgres
--

ALTER TABLE ONLY unimia.storicovalutazioni
    ADD CONSTRAINT storicovalutazioni_pkey PRIMARY KEY (appello, studente);


--
-- Name: studenti studenti_matricola_key; Type: CONSTRAINT; Schema: unimia; Owner: postgres
--

ALTER TABLE ONLY unimia.studenti
    ADD CONSTRAINT studenti_matricola_key UNIQUE (matricola);


--
-- Name: studenti studenti_pkey; Type: CONSTRAINT; Schema: unimia; Owner: postgres
--

ALTER TABLE ONLY unimia.studenti
    ADD CONSTRAINT studenti_pkey PRIMARY KEY (id);


--
-- Name: utenti utenti_email_key; Type: CONSTRAINT; Schema: unimia; Owner: postgres
--

ALTER TABLE ONLY unimia.utenti
    ADD CONSTRAINT utenti_email_key UNIQUE (email);


--
-- Name: utenti utenti_pkey; Type: CONSTRAINT; Schema: unimia; Owner: postgres
--

ALTER TABLE ONLY unimia.utenti
    ADD CONSTRAINT utenti_pkey PRIMARY KEY (id);


--
-- Name: iscrizioniesami i_controllo_iscrizione; Type: TRIGGER; Schema: unimia; Owner: postgres
--

CREATE TRIGGER i_controllo_iscrizione BEFORE INSERT ON unimia.iscrizioniesami FOR EACH ROW EXECUTE FUNCTION unimia.controllo_iscrizione();


--
-- Name: insegnamenti i_u_check_anno_insegnamento; Type: TRIGGER; Schema: unimia; Owner: postgres
--

CREATE TRIGGER i_u_check_anno_insegnamento BEFORE INSERT OR UPDATE ON unimia.insegnamenti FOR EACH ROW EXECUTE FUNCTION unimia.check_anno_insegnamento();


--
-- Name: propedeuticita i_u_check_propedeuticita; Type: TRIGGER; Schema: unimia; Owner: postgres
--

CREATE TRIGGER i_u_check_propedeuticita BEFORE INSERT OR UPDATE ON unimia.propedeuticita FOR EACH ROW EXECUTE FUNCTION unimia.check_propedeuticita();


--
-- Name: appelli i_u_correttazza_calendario_appelli; Type: TRIGGER; Schema: unimia; Owner: postgres
--

CREATE TRIGGER i_u_correttazza_calendario_appelli BEFORE INSERT OR UPDATE ON unimia.appelli FOR EACH ROW EXECUTE FUNCTION unimia.correttazza_calendario_appelli();


--
-- Name: insegnamenti i_u_numeroinsegnamenti_docente; Type: TRIGGER; Schema: unimia; Owner: postgres
--

CREATE TRIGGER i_u_numeroinsegnamenti_docente BEFORE INSERT OR UPDATE ON unimia.insegnamenti FOR EACH ROW EXECUTE FUNCTION unimia.check_numeroinsegnamenti_docente();


--
-- Name: appelli appelli_insegnamento_fkey; Type: FK CONSTRAINT; Schema: unimia; Owner: postgres
--

ALTER TABLE ONLY unimia.appelli
    ADD CONSTRAINT appelli_insegnamento_fkey FOREIGN KEY (insegnamento) REFERENCES unimia.insegnamenti(id) ON UPDATE CASCADE;


--
-- Name: esitiesami esitiesami_appello_fkey; Type: FK CONSTRAINT; Schema: unimia; Owner: postgres
--

ALTER TABLE ONLY unimia.esitiesami
    ADD CONSTRAINT esitiesami_appello_fkey FOREIGN KEY (appello) REFERENCES unimia.appelli(id) ON UPDATE CASCADE;


--
-- Name: esitiesami esitiesami_studente_fkey; Type: FK CONSTRAINT; Schema: unimia; Owner: postgres
--

ALTER TABLE ONLY unimia.esitiesami
    ADD CONSTRAINT esitiesami_studente_fkey FOREIGN KEY (studente) REFERENCES unimia.studenti(id) ON UPDATE CASCADE;


--
-- Name: insegnamenti insegnamenti_corsodilaurea_fkey; Type: FK CONSTRAINT; Schema: unimia; Owner: postgres
--

ALTER TABLE ONLY unimia.insegnamenti
    ADD CONSTRAINT insegnamenti_corsodilaurea_fkey FOREIGN KEY (corsodilaurea) REFERENCES unimia.corsidilaurea(id) ON UPDATE CASCADE;


--
-- Name: insegnamenti insegnamenti_docente_fkey; Type: FK CONSTRAINT; Schema: unimia; Owner: postgres
--

ALTER TABLE ONLY unimia.insegnamenti
    ADD CONSTRAINT insegnamenti_docente_fkey FOREIGN KEY (docente) REFERENCES unimia.docenti(id) ON UPDATE CASCADE;


--
-- Name: iscrizioniesami iscrizioniesami_appello_fkey; Type: FK CONSTRAINT; Schema: unimia; Owner: postgres
--

ALTER TABLE ONLY unimia.iscrizioniesami
    ADD CONSTRAINT iscrizioniesami_appello_fkey FOREIGN KEY (appello) REFERENCES unimia.appelli(id) ON UPDATE CASCADE;


--
-- Name: iscrizioniesami iscrizioniesami_studente_fkey; Type: FK CONSTRAINT; Schema: unimia; Owner: postgres
--

ALTER TABLE ONLY unimia.iscrizioniesami
    ADD CONSTRAINT iscrizioniesami_studente_fkey FOREIGN KEY (studente) REFERENCES unimia.studenti(id) ON UPDATE CASCADE;


--
-- Name: propedeuticita propedeuticita_insegnamento_fkey; Type: FK CONSTRAINT; Schema: unimia; Owner: postgres
--

ALTER TABLE ONLY unimia.propedeuticita
    ADD CONSTRAINT propedeuticita_insegnamento_fkey FOREIGN KEY (insegnamento) REFERENCES unimia.insegnamenti(id) ON UPDATE CASCADE;


--
-- Name: propedeuticita propedeuticita_insegnamentopropedeutico_fkey; Type: FK CONSTRAINT; Schema: unimia; Owner: postgres
--

ALTER TABLE ONLY unimia.propedeuticita
    ADD CONSTRAINT propedeuticita_insegnamentopropedeutico_fkey FOREIGN KEY (insegnamentopropedeutico) REFERENCES unimia.insegnamenti(id) ON UPDATE CASCADE;


--
-- Name: storicoiscrizioni storicoiscrizioni_appello_fkey; Type: FK CONSTRAINT; Schema: unimia; Owner: postgres
--

ALTER TABLE ONLY unimia.storicoiscrizioni
    ADD CONSTRAINT storicoiscrizioni_appello_fkey FOREIGN KEY (appello) REFERENCES unimia.appelli(id) ON UPDATE CASCADE;


--
-- Name: storicoiscrizioni storicoiscrizioni_studente_fkey; Type: FK CONSTRAINT; Schema: unimia; Owner: postgres
--

ALTER TABLE ONLY unimia.storicoiscrizioni
    ADD CONSTRAINT storicoiscrizioni_studente_fkey FOREIGN KEY (studente) REFERENCES unimia.storicostudenti(id) ON UPDATE CASCADE;


--
-- Name: storicostudenti storicostudenti_corsodilaurea_fkey; Type: FK CONSTRAINT; Schema: unimia; Owner: postgres
--

ALTER TABLE ONLY unimia.storicostudenti
    ADD CONSTRAINT storicostudenti_corsodilaurea_fkey FOREIGN KEY (corsodilaurea) REFERENCES unimia.corsidilaurea(id) ON UPDATE CASCADE;


--
-- Name: storicostudenti storicostudenti_id_fkey; Type: FK CONSTRAINT; Schema: unimia; Owner: postgres
--

ALTER TABLE ONLY unimia.storicostudenti
    ADD CONSTRAINT storicostudenti_id_fkey FOREIGN KEY (id) REFERENCES unimia.utenti(id);


--
-- Name: storicovalutazioni storicovalutazioni_appello_fkey; Type: FK CONSTRAINT; Schema: unimia; Owner: postgres
--

ALTER TABLE ONLY unimia.storicovalutazioni
    ADD CONSTRAINT storicovalutazioni_appello_fkey FOREIGN KEY (appello) REFERENCES unimia.appelli(id) ON UPDATE CASCADE;


--
-- Name: storicovalutazioni storicovalutazioni_studente_fkey; Type: FK CONSTRAINT; Schema: unimia; Owner: postgres
--

ALTER TABLE ONLY unimia.storicovalutazioni
    ADD CONSTRAINT storicovalutazioni_studente_fkey FOREIGN KEY (studente) REFERENCES unimia.storicostudenti(id) ON UPDATE CASCADE;


--
-- Name: studenti studenti_corsodilaurea_fkey; Type: FK CONSTRAINT; Schema: unimia; Owner: postgres
--

ALTER TABLE ONLY unimia.studenti
    ADD CONSTRAINT studenti_corsodilaurea_fkey FOREIGN KEY (corsodilaurea) REFERENCES unimia.corsidilaurea(id) ON UPDATE CASCADE;


--
-- PostgreSQL database dump complete
--

