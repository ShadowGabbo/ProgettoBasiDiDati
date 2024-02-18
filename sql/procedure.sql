-- aggiunge un nuovo studente
-- aggiunge anche le sue credenziali nella tabella utenti
CREATE OR REPLACE PROCEDURE add_student(
    _email text, 
    _password text, 
    _nome text, 
    _cognome text,
    _cdl char(6)
) 
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

-- modifica uno studente dato il suo id
CREATE OR REPLACE PROCEDURE update_student (
    _id uuid,
    _nome TEXT,
    _cognome TEXT,
    _email TEXT,
    _matricola CHAR(6),
    _corso_di_laurea VARCHAR(6)
)
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

-- aggiunge un nuovo docente
-- aggiunge anche le sue credenziali nella tabella utenti
CREATE OR REPLACE PROCEDURE add_teacher(
    _email text, 
    _password text, 
    _nome text, 
    _cognome text
) 
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

-- modifica un docente dato il suo id
CREATE OR REPLACE PROCEDURE update_teacher (
    _id uuid,
    _nome TEXT,
    _cognome TEXT,
    _email TEXT
)
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

-- aggiunge un nuovo segretario/a
-- aggiunge anche le sue credenziali nella tabella utenti
CREATE OR REPLACE PROCEDURE add_secretary(
    _email text, 
    _password text, 
    _nome text, 
    _cognome text
) 
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

-- aggiunge un nuovo cdl (corso di laurea)
CREATE OR REPLACE PROCEDURE add_cdl(
    _id varchar(6), 
    _nome text, 
    _tipo TIPO_CORSO_LAUREA, 
    _desc text
) 
LANGUAGE plpgsql
AS $$
    BEGIN    
        SET search_path TO unimia;

        -- inserimento del cdl
        INSERT INTO corsiDiLaurea(id,nome,tipo,descrizione) VALUES (_id, _nome, _tipo, _desc);
    END;
$$;

-- modifica la password di un utente
CREATE OR REPLACE PROCEDURE edit_password(
    _id uuid, 
    _newpassword text
) 
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

-- aggiunge un insegnamento (con responsabile e esami propedeutici)
CREATE OR REPLACE PROCEDURE add_insegnamento(
    _id varchar(6),
    _nome text,
    _descrizione text,
    _anno TIPO_ANNO,
    _cfu smallint,
    _corsoDiLaurea varchar(6),
    _docente uuid,
    _propedeutici varchar(6)[]
)
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

-- aggiunge un appello per un insegnamento
-- crea un appello
CREATE OR REPLACE PROCEDURE add_appello (
  _insegnamento VARCHAR(6),
  _data DATE,
  _ora TIME,
  _luogo TEXT
)
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

-- aggiunge l'iscrizione dello studente per un appello
CREATE OR REPLACE PROCEDURE add_iscrizione_studente (
  _id_appello uuid,
  _id_studente uuid
)
LANGUAGE plpgsql
AS $$
    BEGIN
        SET search_path TO unimia;

        -- aggiungo l'iscrizione dell appello per lo studente
        INSERT INTO iscrizioniesami(studente, appello) VALUES (_id_studente, _id_appello);
    END;
$$;

-- da il voto allo studente per un certo esame/appello
CREATE OR REPLACE PROCEDURE add_valutazione_esame (
  _id_appello uuid,
  _id_studente uuid,
  _voto smallint
)
LANGUAGE plpgsql
AS $$
    DECLARE _data_appello DATE;
    BEGIN
        SET search_path TO unimia;

        -- prendo la data dell appello
        SELECT A.data INTO _data_appello FROM appelli AS A WHERE A.id = _id_appello; 

        -- controllo se lo posso valutare
        IF _data_appello > Now() THEN
            raise exception E'Errore appello da valutare deve essere passato';
        END IF;

        -- metto la valutazione
        INSERT INTO esitiesami(studente, appello, voto) VALUES (_id_studente, _id_appello, _voto);
    END;
$$;

-- disiscrive uno studente ad un appello
CREATE OR REPLACE PROCEDURE disiscriviti_studente(
    _id_studente uuid,
    _id_appello uuid
)
LANGUAGE plpgsql
AS $$
    BEGIN

    SET search_path TO unimia;

    DELETE FROM iscrizioniesami AS I WHERE I.appello = _id_appello AND I.studente = _id_studente;

    END;
$$;

-- elimina uno studente dato il suo id (spostandolo nell'archivio grazie al trigger)
-- manca trigger e tabella
CREATE OR REPLACE PROCEDURE remove_student (
    _id uuid
)
LANGUAGE plpgsql
AS $$
    BEGIN

    SET search_path TO unimia;

    DELETE FROM studenti
    WHERE id = _id;
END;
$$;

-- archivia uno studente per una motivazione 
-- e' la segreteria a scegliere il motivo dell'archiviazione
CREATE OR REPLACE PROCEDURE archivia_studente(
    _motivazione TIPO_MOTIVO,
    _id uuid
)
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

-- elimia il docente (e il suo utente associato se non ci sono vincoli di foreign key)
CREATE OR REPLACE PROCEDURE delete_docente (
  _id uuid
)
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