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

-- restituisce tutti i corsi di laurea (cdl)
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

-- restituisce gli insegnamenti di cui e' responsabile/insegna (max 3)
CREATE OR REPLACE FUNCTION get_insegnamenti_docente(
    _docente uuid
)RETURNS TABLE(
    _id varchar(6),
    _nome text,
    _descrizione text,
    _anno TIPO_ANNO,
    _cfu smallint,
    _nome_corsoDiLaurea text
)
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

CREATE OR REPLACE FUNCTION get_appelli_docente(
    _docente uuid
)RETURNS TABLE(
    id uuid,
    data DATE,
    orario TIME, 
    luogo text,
    nome_insegnamento text,
    nome_corso text
)
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
