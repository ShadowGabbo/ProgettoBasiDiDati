-- inserimento di nuovi studenti
CALL add_student('gabry@studente.it', 'ciaoatutti', 'Gabriele', 'Sarti', '034312');
CALL add_student('mario@studente.it', 'ciaobella', 'Mario', 'Rossi', '098214');
CALL add_student('rosa@studente.it', 'ciaorosa', 'Rosa', 'Verdi', '784512');
CALL add_student('gianfranco@studente.it', 'gianni', 'Gianfranco', 'Gialli', '784512');
CALL add_student('franco@studente.it', 'wewew', 'Franco', 'Nero', '981232');

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

-- inserimento di nuovi insegnamenti
CALL add_insegnamento('231562', 'basi di dati', 'per capire i db', '2', 12::smallint, '034312', uuid('f18d6bed-7022-430b-a549-aa8a7b763d27'), NULL); 
CALL add_insegnamento('129813', 'algoritmi', 'strutture dati', '2', 12::smallint, '034312', uuid('84bf9cda-3bc2-4d6b-937c-00a2e1924a08'), NULL);
CALL add_insegnamento('758192', 'programmazione 1', 'per iniziare', '1', 12::smallint, '034312', uuid('84bf9cda-3bc2-4d6b-937c-00a2e1924a08'), NULL);
CALL add_insegnamento('364912', 'programmazione 2', 'oop oggetti evviva', '2', 6::smallint, '034312', uuid('84bf9cda-3bc2-4d6b-937c-00a2e1924a08'), '{758192}');
CALL add_insegnamento('562418', 'reti', 'reti web', '3', 12::smallint, '034312', uuid('f18d6bed-7022-430b-a549-aa8a7b763d27'), '{758192, 231562}');

-- dovrebbe sollevare eccezione lanciata dal trigger perche' il docente ha gia' 3 insegnamenti di cui e' responsabile
CALL add_insegnamento('511298', 'matematica del continuo', 'viva la matematica', '1', 12::smallint, '034312', uuid('84bf9cda-3bc2-4d6b-937c-00a2e1924a08'), NULL);

-- dovrebbe sollevare eccezione lanciata dal trigger perche' l'insegnamento non puo' essere erogato a terzo anno se il cdl ha 2 anni (magistrale)
CALL add_insegnamento('568910', 'machine learning', 'corso di ai fondamentale', '3', 6::smallint, '098214', uuid('e4910308-f130-4373-a495-d37b75cb38e0'), NULL);

-- dovrebbe sollevare eccezione lanciata dal trigger perche' l'insegnamento non puo' essere erogato al quarto anno se il cdl ha 3 anni (triennale)
CALL add_insegnamento('817829', 'sistemi operativi', 'imparare ad usare linux', '4', 12::smallint, '098214', uuid('e4910308-f130-4373-a495-d37b75cb38e0'), NULL);

-- dovrebbe sollevare eccezione lanciata dal trigger perche' l'insegnamento non puo' essere propedeutico a se stesso
CALL add_insegnamento('817829', 'sistemi operativi', 'imparare ad usare linux', '1', 12::smallint, '098214', uuid('e4910308-f130-4373-a495-d37b75cb38e0'), '{817829}');
