-- aggiunge un nuovo studente
-- aggiunge anche le sue credenziali nella tabella utenti
CREATE OR REPLACE PROCEDURE add_student(
    _email text, 
    _password text, 
    _nome text, 
    _cognome text,
    _matricola char(6),
    _cdl char(6)
) 
LANGUAGE plpgsql
AS $$
    DECLARE _id uuid;
    BEGIN    
        SET search_path TO unimia;

        -- inserimento delle credenziali dello studente
        INSERT INTO utenti(email, password, tipo, nome, cognome) VALUES (_email, _password, 'studente', _nome, _cognome) RETURNING id INTO _id;

        -- inserimento dello studente
        INSERT INTO studenti(id, matricola, corsoDiLaurea) VALUES (_id, _matricola, _cdl);
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