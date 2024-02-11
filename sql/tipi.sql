-- tipi di utenti possibili nel database
CREATE TYPE TIPO_UTENTI AS ENUM ('studente', 'docente', 'segretario', 'ex_studente');

-- tipi di corsi di laurea
CREATE TYPE TIPO_CORSO_LAUREA AS ENUM ('triennale', 'magistrale', 'magistrale a ciclo unico');