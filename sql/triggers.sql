-- da testare
CREATE OR REPLACE FUNCTION check_numeroinsegnamenti_docente() RETURNS TRIGGER 
LANGUAGE plpgsql
AS $$
    DECLARE _counter INTEGER;
    BEGIN
        SET search_path TO unimia;

        -- conto il numero di insegnamenti di cui il docente è responsabile (max 3 insegnamenti per docente)
        SELECT COUNT(*)
        FROM insegnamenti AS I
        WHERE I.responsabile = NEW.docente
        AND I.id != NEW.id
        INTO _counter;

        IF _counter = 3 THEN
            RAISE EXCEPTION 'Il docente è reponsabile già di 3 insegnamenti';
        END IF;

        RETURN NEW;
    END;
$$;

CREATE OR REPLACE TRIGGER i_u_numeroinsegnamenti_docente
    BEFORE INSERT OR UPDATE ON insegnamenti
    FOR EACH ROW
    EXECUTE PROCEDURE check_numeroinsegnamenti_docente();