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


CREATE OR REPLACE FUNCTION genera_matricola() RETURNS TRIGGER 
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

-- aggiunge la matricola quando si aggiungono nuovi stundenti
-- vedere sopra per la procedura
CREATE OR REPLACE TRIGGER i_genera_matricola
    BEFORE INSERT ON studenti
    FOR EACH ROW
    EXECUTE PROCEDURE genera_matricola();


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