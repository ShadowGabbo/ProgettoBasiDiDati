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



CREATE OR REPLACE FUNCTION controllo_iscrizione() RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
    DECLARE 
        _insegnamento_appello varchar(6);
        _cdl_appello varchar(6);
        _cdl_studente varchar(6);
        _counter integer;
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