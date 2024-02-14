-- tipi di utenti possibili nel database
CREATE TYPE TIPO_UTENTI AS ENUM ('studente', 'docente', 'segretario', 'ex_studente');

-- tipi di corsi di laurea
CREATE TYPE TIPO_CORSO_LAUREA AS ENUM ('triennale', 'magistrale', 'magistrale a ciclo unico');

-- tipo anno insegnamento (da 1 a 3 per triennale, da 1 a 2 per le magistrali, da 1 a 5 per le magistrali a ciclo unico)
CREATE TYPE TIPO_ANNO AS ENUM ('1', '2', '3', '4', '5');

-- motivazioni dell'archiviazione di uno studente
CREATE TYPE TIPO_MOTIVO AS ENUM ('rinuncia', 'laurea');