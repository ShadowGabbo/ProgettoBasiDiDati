-- inserimento di nuovi studenti
CALL add_student('gabry@studente.it', 'ciaoatutti', 'Gabriele', 'Sarti', '975112', '034312');
CALL add_student('mario@studente.it', 'ciaobella', 'Mario', 'Rossi', '975232', '098214');
CALL add_student('rosa@studente.it', 'ciaorosa', 'Rosa', 'Verdi', '912112', '784512');

-- inserimento di nuovi docenti
CALL add_teacher('fernando@docente.it', 'fernando', 'Fernando', 'Neri');
CALL add_teacher('pino@docente.it', 'pinotto', 'Pino', 'Rossi');
CALL add_teacher('laura@docente.it', 'laura', 'Laura', 'Boni');

-- inserimento di nuovi segretari
CALL add_secretary('mario@segreteria.it', 'mario', 'Mario', 'Rossi');
CALL add_secretary('alberto@segreteria.it', 'calcio', 'Alberto', 'Verdi');
CALL add_secretary('gaia@segreteria.it', 'password', 'Gaia', 'Gialli');

-- inserimento di nuovi corsi di studio
CALL add_cdl('875371', 'fisioterapia', 'magistrale', 'per far star bene i muscoli');
CALL add_cdl('034312', 'informatica', 'triennale', 'corso sui computer');
CALL add_cdl('098214', 'ai', 'magistrale', 'corso sulla inteligenza artificiale');
CALL add_cdl('874124', 'biochimica', 'magistrale a ciclo unico', 'corso sulle piante');
CALL add_cdl('981232', 'assistenza sanitaria', 'triennale', 'corso per infermiere');
CALL add_cdl('784512', 'chimica', 'magistrale a ciclo unico', 'corso per i chimici');