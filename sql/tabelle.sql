CREATE TABLE utenti (
    id uuid PRIMARY KEY DEFAULT get_random_uuid(),
    email varchar(30) NOT NULL UNIQUE,
    password varchar(20) NOT NULL,
    nome varchar(30) NOT NULL,
    cognome varchar(30) NOT NULL,
);

INSERT INTO utenti AS(email, password, nome, cognome) VALUES ("gabry@studenti.unimi.it", "ciaoatutti", "Gabriele", "Sarti");
INSERT INTO utenti AS(email, password, nome, cognome) VALUES ("mario@studenti.unimi.it", "ciaomario", "Mario", "Rossi");

CREATE TABLE corsiDiLaurea (
    id char(6) PRIMARY KEY,
    nome varchar(50) NOT NULL,
    tipo TIPO_CORSO_LAUREA NOT NULL,
    descrizione text NOT NULL
);

-- politica di integrita' referenziale su corso di laurea ON UPDATE CASCADE
-- se modifico un corso di laurea lo modifico anche qui nella tabella studenti
-- se cancello un corso di laurea persiste il record studente
CREATE TABLE studenti (
    id uuid PRIMARY KEY REFERENCES utenti(id),
    matricola char(6) NOT NULL UNIQUE,
    corsoDiLaurea char(6) NOT NULL REFERENCES corsiDiLaurea(id) ON UPDATE CASCADE
);

CREATE TABLE storicoStudenti (
    id uuid PRIMARY KEY REFERENCES utenti(id),
    matricola char(6) NOT NULL UNIQUE,
    motivo TIPO_MOTIVO NOT NULL,
    corsoDiLaurea char(6) NOT NULL REFERENCES corsiDiLaurea(id) ON UPDATE CASCADE
);

CREATE TABLE docenti (
    id uuid PRIMARY KEY REFERENCES utenti(id)
)

CREATE TABLE segreteria (
    id uuid PRIMARY KEY REFERENCES utenti(id)
)

CREATE TABLE insegnamenti (
    id char(6) PRIMARY KEY,
    nome varchar(30) NOT NULL,
    descrizione text NOT NULL,
    anno TIPO_ANNO NOT NULL,
    cfu TIPO_CFU NOT NULL,
    corsoDiLaurea char(6) NOT NULL REFERENCES corsiDiLaurea(id) ON UPDATE CASCADE,
    docente uuid NOT NULL REFERENCES docenti(id) ON UPDATE CASCADE
)

CREATE TABLE appelli (
    id uuid PRIMARY KEY DEFAULT get_random_uuid(),
    data DATA NOT NULL,
    orario TIME NOT NULL, 
    luogo text NOT NULL,
    insegnamento char(6) NOT NULL REFERENCES insegnamenti(id) ON UPDATE CASCADE
)

CREATE TABLE iscrizioniEsami (
    studente uuid NOT NULL REFERENCES studenti(id) ON UPDATE CASCADE ON DELETE CASCADE
    appello uuid NOT NULL REFERENCES appello(id) ON UPDATE CASCADE ON DELETE CASCADE
    PRIMARY KEY (appello, studente)
)

CREATE TABLE esitiEsami (
    studente uuid NOT NULL REFERENCES studenti(id) ON UPDATE CASCADE ON DELETE CASCADE
    appello uuid NOT NULL REFERENCES appello(id) ON UPDATE CASCADE
    voto INTEGER CHECK (voto BETWEEN 0 AND 31),
    PRIMARY KEY (appello, studente)
) 

CREATE TABLE propedeuticita (
    insegnamento char(6) NOT NULL REFERENCES insegnamenti(id) ON UPDATE CASCADE,
    insegnamentoPropedeutico char(6) NOT NULL REFERENCES insegnamenti(id) ON UPDATE CASCADE,
    PRIMARY KEY(insegnamento, insegnamentoPropedeutico)
)

CREATE TABLE storicoIscrizioni (
    studente uuid NOT NULL REFERENCES storicoStudenti(id) ON UPDATE CASCADE ON DELETE CASCADE
    appello uuid NOT NULL REFERENCES appello(id) ON UPDATE CASCADE
    PRIMARY KEY (appello, studente)
)

CREATE TABLE storicoEsiti (
    studente uuid NOT NULL REFERENCES storicoStudenti(id) ON UPDATE CASCADE ON DELETE CASCADE
    appello uuid NOT NULL REFERENCES appello(id) ON UPDATE CASCADE
    voto INTEGER CHECK (voto BETWEEN 0 AND 31),
    PRIMARY KEY (appello, studente)
)

