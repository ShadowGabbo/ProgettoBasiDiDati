CREATE TABLE utenti (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    email text NOT NULL UNIQUE CHECK (email ~* '^[A-Za-z0-9._%-]+@studente|docente|segreteria.it$'),
    password text NOT NULL CHECK (length(password) > 3),
    tipo TIPO_UTENTI NOT NULL,
    nome text NOT NULL CHECK (nome ~* '^.+$'),
    cognome text NOT NULL CHECK (cognome ~* '^.+$')
);

CREATE TABLE corsiDiLaurea (
    id varchar(6) PRIMARY KEY,
    nome text NOT NULL,
    tipo TIPO_CORSO_LAUREA NOT NULL,
    descrizione text NOT NULL
);

CREATE TABLE studenti (
    id uuid PRIMARY KEY REFERENCES utenti(id),
    matricola char(6) NOT NULL UNIQUE CHECK (matricola ~* '^\d{6}$'),
    corsoDiLaurea char(6) NOT NULL REFERENCES corsiDiLaurea(id) ON UPDATE CASCADE
);

CREATE TABLE docenti (
    id uuid PRIMARY KEY REFERENCES utenti(id)
);

CREATE TABLE segreteria (
    id uuid PRIMARY KEY REFERENCES utenti(id)
);


CREATE TABLE storicoStudenti (
    id uuid PRIMARY KEY REFERENCES utenti(id),
    matricola char(6) NOT NULL UNIQUE,
    motivo TIPO_MOTIVO NOT NULL,
    corsoDiLaurea char(6) NOT NULL REFERENCES corsiDiLaurea(id) ON UPDATE CASCADE
);

CREATE TABLE insegnamenti (
    id varchar(6) PRIMARY KEY,
    nome text NOT NULL,
    descrizione text NOT NULL,
    anno TIPO_ANNO NOT NULL,
    cfu smallint NOT NULL CHECK (cfu > 0 AND cfu <= 15),
    corsoDiLaurea varchar(6) NOT NULL REFERENCES corsiDiLaurea(id) ON UPDATE CASCADE,
    docente uuid NOT NULL REFERENCES docenti(id) ON UPDATE CASCADE
)

CREATE TABLE appelli (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    data DATE NOT NULL,
    orario TIME NOT NULL, 
    luogo text NOT NULL,
    insegnamento varchar(6) NOT NULL REFERENCES insegnamenti(id) ON UPDATE CASCADE
)

CREATE TABLE iscrizioniEsami (
    studente uuid NOT NULL REFERENCES studenti(id) ON UPDATE CASCADE,
    appello uuid NOT NULL REFERENCES appelli(id) ON UPDATE CASCADE,
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

