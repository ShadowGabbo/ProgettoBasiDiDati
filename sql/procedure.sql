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