-- restituisce tutti gli studenti
CREATE OR REPLACE FUNCTION get_all_students() 
RETURNS TABLE(
    _id uuid,
    _nome text,
    _cognome text,
    _email text,
    _matricola char(6),
    _nome_corsoDiLaurea text
) 
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

-- restituisce tutti i docenti
CREATE OR REPLACE FUNCTION get_all_teachers() 
RETURNS TABLE(
    _id uuid,
    _nome text,
    _cognome text,
    _email text
) 
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

-- restituisce tutti i corsi di laurea (cdl)
CREATE OR REPLACE FUNCTION get_all_courses() 
RETURNS TABLE(
    _id varchar(6),
    _nome text,
    _tipo TIPO_CORSO_LAUREA,
    _descrizione text
) 
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