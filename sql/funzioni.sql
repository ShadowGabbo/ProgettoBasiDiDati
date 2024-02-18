-- restituisce uno studente dato il proprio id
CREATE OR REPLACE FUNCTION get_student(
    _id_studente uuid
) 
RETURNS TABLE(
    _id uuid,
    _nome text,
    _cognome text,
    _email text,
    _matricola char(6),
    _corso varchar(6)
) 
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

-- restituisce un docente dato il suo id
CREATE OR REPLACE FUNCTION get_teacher (
  _id_teacher uuid
)
RETURNS TABLE (
    _id uuid,
    _nome TEXT,
    _cognome TEXT,
    _email TEXT
)
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

-- restituisce i nomi di tutti gli insegnammenti propedeutici a quello passato come argomento 
CREATE OR REPLACE FUNCTION get_all_insegnamenti_propedeutici(
    _id_insegnamento varchar(6)
)
RETURNS TABLE(
    _propedeutici text
)LANGUAGE plpgsql
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

/*
 * Restituisce tutti gli appelli per uno studente
 * (Gli appelli del proprio corso di studio del futuro)
 */
CREATE OR REPLACE FUNCTION get_all_appelli(
    _id_studente uuid
) RETURNS TABLE (
    _id_appello uuid,
    _nome_insegnamento text,
    _nome_corso text,
    _nome_docente text,
    _data DATE,
    _orario TIME, 
    _luogo text
)
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

-- restituisce tutte le iscrizioni agli esami di uno studente (ossia gli appelli)
CREATE OR REPLACE FUNCTION get_all_iscrizioni(
    _id_studente uuid
) RETURNS TABLE (
    _id_appello uuid,
    _nome_insegnamento text,
    _data DATE,
    _orario TIME, 
    _luogo text
)
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

-- restituisce tutti gli esami da valutare per un docente
CREATE OR REPLACE FUNCTION get_esami_valutare_docente(
    _docente uuid
)RETURNS TABLE (
    _appello uuid,
    _nome_insegnamento TEXT,
    _data DATE,
    _studente uuid,
    _matricola CHAR(6),
    _nome TEXT
)
LANGUAGE plpgsql
AS $$
    DECLARE 
    BEGIN    
        SET search_path TO unimia;

        -- trovo tutti gli esami che il docente possa valutare
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