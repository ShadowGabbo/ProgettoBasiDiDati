<?php
/**
 * Fa i redirect tra le pagine php
 */
function redirect($url, $permanent = false) {
    header("Location: $url", true, $permanent ? 301 : 302);
    exit();
}

/**
 * Per debug
 */
function parseError($error) {
    $startPos = strpos($error, "ERROR:");
  
    $endPos1 = strpos($error, "DETAIL"); // end position for "default" errors
    $endPos2 = strpos($error, "CONTEX"); // end position for custom trigger exceptions
    
    $endPos1 = $endPos1 ? $endPos1 : PHP_INT_MAX;
    $endPos2 = $endPos2 ? $endPos2 : PHP_INT_MAX;
  
    return substr($error, $startPos + 7, min($endPos1, $endPos2) - $startPos - 8);
  }

/**
 * Apre la connessione con il server db
 */
function open_pg_connection(){
    include_once('../conf/conf.php');
    $conn = "host=".myhost." dbname=".mydb." user=".myuser." password=".mypass;
    return pg_connect($conn);
}

/**
 * Chiude la connessione con il server db
 */
function close_pg_connection($db){
    return pg_close($db);
}

/**
 * Controlla il login (email tipo e password)
 * 
 * Restituisce un flag true se login andato correttamente false altrimenti
 * Restituisce l'id dell utente loggato
 */
function check_login($usr, $psw, $tipo){
    $db = open_pg_connection();
    $params = array($usr, $psw, $tipo); 
    $sql = 
        "SELECT U.id FROM unimia.utenti AS U
         WHERE U.email = $1 AND U.password = $2 AND U.tipo = $3";
    $result = pg_prepare($db, 'login', $sql);
    $result = pg_execute($db, 'login', $params);
    close_pg_connection($db);

    if ($id = pg_fetch_assoc($result)) return array(true, $id); // trovato il record
    else return array(false, null);
}

/**
 * Restituisce la matricola dello studente con id
 */
function get_matricola($id){
    $db = open_pg_connection();
    $params = array($id); 
    $sql = 
        "SELECT S.matricola FROM unimia.studenti AS S
         WHERE S.id = $1;";
    $result = pg_prepare($db, 'matricola', $sql);
    $result = pg_execute($db, 'matricola', $params);
    close_pg_connection($db);

    return pg_fetch_assoc($result)['matricola'];
}

/**
 * Restituisce il nome del corso di studio dello studente con id
 */
function get_corsodistudi($id){
    $db = open_pg_connection();
    $params = array($id); 
    $sql = 
        "SELECT C.nome 
         FROM unimia.studenti AS S
         JOIN unimia.corsidilaurea AS C ON S.corsodilaurea = C.id
         WHERE S.id = $1;";
    $result = pg_prepare($db, 'matricola', $sql);
    $result = pg_execute($db, 'matricola', $params);
    close_pg_connection($db);

    return pg_fetch_assoc($result)['nome'];
}

function get_credenziali($id){
    $db = open_pg_connection();
    $params = array($id); 
    $sql = 
        "SELECT U.* FROM unimia.utenti AS U
        WHERE U.id = $1;";
    $result = pg_prepare($db, 'credenziali', $sql);
    $result = pg_execute($db, 'credenziali', $params);
    close_pg_connection($db);

    return pg_fetch_assoc($result);
}

function change_password($id, $newpassword){
    $db = open_pg_connection();
    $params = array($id, $newpassword); 
    $sql = "CALL unimia.edit_password($1, $2);";
    $result = pg_prepare($db, 'credenziali', $sql);
    $result = pg_execute($db, 'credenziali', $params);
    close_pg_connection($db);

    return $result;
}

function get_students(){
    $db = open_pg_connection();
    $sql = "SELECT * FROM unimia.get_all_students();";
    $result = pg_prepare($db, 'ottieni studenti', $sql);
    $result = pg_execute($db, 'ottieni studenti', array());
    close_pg_connection($db);

    $students = array();
    while($row = pg_fetch_assoc($result)){
        $id = $row['_id'];
        $nome = $row['_nome'];
        $cognome = $row['_cognome'];
        $email = $row['_email'];
        $matricola = $row['_matricola'];
        $nomecorso = $row['_nome_corsodilaurea'];
        $student = array($id, $nome, $cognome, $email, $matricola, $nomecorso);
        array_push($students, $student);
    }
    return $students;
}

function get_teachers(){
    $db = open_pg_connection();
    $sql = "SELECT * FROM unimia.get_all_teachers();";
    $result = pg_prepare($db, 'ottieni docenti', $sql);
    $result = pg_execute($db, 'ottieni docenti', array());
    close_pg_connection($db);

    $teachers = array();
    while($row = pg_fetch_assoc($result)){
        $id = $row['_id'];
        $nome = $row['_nome'];
        $cognome = $row['_cognome'];
        $email = $row['_email'];
        $teacher = array($id, $nome, $cognome, $email);
        array_push($teachers, $teacher);
    }
    return $teachers;
}

function get_courses(){
    $db = open_pg_connection();
    $sql = "SELECT * FROM unimia.get_all_courses();";
    $result = pg_prepare($db, 'ottieni corsi', $sql);
    $result = pg_execute($db, 'ottieni corsi', array());
    close_pg_connection($db);

    $courses = array();
    while($row = pg_fetch_assoc($result)){
        $id = $row['_id'];
        $nome = $row['_nome'];
        $tipo = $row['_tipo'];
        $descrizione = $row['_descrizione'];
        $course = array($id, $nome, $tipo, $descrizione);
        array_push($courses, $course);
    }
    return $courses;
}


function get_name_course($id){
    $db = open_pg_connection();
    $sql = "SELECT C.nome FROM unimia.corsidilaurea AS C WHERE C.id = $1;";
    $result = pg_prepare($db, 'ottieni nome', $sql);
    $result = pg_execute($db, 'ottieni nome', array($id));
    close_pg_connection($db);
    return pg_fetch_assoc($result)['nome'];
}

function get_insegnamenti_docente($id){
    $db = open_pg_connection();
    $sql = "SELECT * FROM unimia.get_insegnamenti_docente($1);";
    $result = pg_prepare($db, 'ottieni insegnamenti docente', $sql);
    $result = pg_execute($db, 'ottieni insegnamenti docente', array($id));
    close_pg_connection($db);

    $insegnamenti = array();
    while($row = pg_fetch_assoc($result)){
        $id = $row['_id'];
        $nome = $row['_nome'];
        $descrizione = $row['_descrizione'];
        $anno = $row['_anno'];
        $cfu = $row['_cfu'];
        $nome_corso = $row['_nome_corsodilaurea'];
        $insegnamento = array($id, $nome, $descrizione, $anno, $cfu, $nome_corso);
        array_push($insegnamenti, $insegnamento);
    }
    return $insegnamenti;
}

/**
 * Restituisce il candario appelli del docente
 */
function calendario_docente($id){
    $db = open_pg_connection();
    $sql = "select * from unimia.get_appelli_docente($1);";
    $result = pg_prepare($db, 'ottieni nome', $sql);
    $result = pg_execute($db, 'ottieni nome', array($id));
    close_pg_connection($db);

    $appelli = array();
    while($row = pg_fetch_assoc($result)){
        $id = $row['id'];
        $nome_insegnamento = $row['nome_insegnamento'];
        $nome_corso = $row['nome_corso'];
        $data = $row['data'];
        $orario = $row['orario'];
        $luogo = $row['luogo'];
        $appello = array($id, $nome_insegnamento, $nome_corso, $data, $orario, $luogo);
        array_push($appelli, $appello);
    }
    return $appelli;
}


/**
 * Restituisce tutti gli insegnamenti dato l'id del corso
 */
function get_all_insegnamenti($id){
    $db = open_pg_connection();
    $sql = "SELECT * FROM unimia.get_all_insegnamenti($1);";
    $result = pg_prepare($db, 'ottieni corsi', $sql);
    $result = pg_execute($db, 'ottieni corsi', array($id));
    close_pg_connection($db);

    $insegnamenti = array();
    while($row = pg_fetch_assoc($result)){
        $id = $row['_id'];
        $nome = $row['_nome'];
        $descrizione = $row['_descrizione'];
        $anno = $row['_anno'];
        $cfu = $row['_cfu'];
        $nome_docente = $row['_nome_docente'];
        $insegnamento = array($id, $nome, $descrizione, $anno, $cfu, $nome_docente);
        array_push($insegnamenti, $insegnamento);
    }
    //print_r($insegnamenti);
    return $insegnamenti;
}

function get_all_propedeutici($id_insegnamento){
    $db = open_pg_connection();
    $sql = "SELECT * FROM unimia.get_all_insegnamenti_propedeutici($1);";
    $result = pg_prepare($db, 'ottieni propedeutici', $sql);
    $result = pg_execute($db, 'ottieni propedeutici', array($id_insegnamento));
    close_pg_connection($db);

    $insegnamenti = array();
    while($row = pg_fetch_assoc($result)){
        $nome_propedeutico = $row['_propedeutici'];
        $insegnamento = $nome_propedeutico;
        array_push($insegnamenti, $insegnamento);
    }
    return $insegnamenti;
}

function get_appelli_studente($id){
    $db = open_pg_connection();
    $sql = "SELECT * FROM unimia.get_all_appelli($1);";
    $result = pg_prepare($db, 'appelli studente', $sql);
    $result = pg_execute($db, 'appelli studente', array($id));
    close_pg_connection($db);

    $appelli = array();
    while($row = pg_fetch_assoc($result)){
        $id = $row['_id_appello'];
        $nome_insegnamento = $row['_nome_insegnamento'];
        $nome_corso = $row['_nome_corso'];
        $nome_docente = $row['_nome_docente'];
        $data = $row['_data'];
        $orario = $row['_orario'];
        $luogo = $row['_luogo'];
        $appello = array($id, $nome_insegnamento, $nome_corso, $nome_docente, $data, $orario, $luogo);
        array_push($appelli, $appello);
    }
    return $appelli;
}

function insert_student($email, $password, $nome, $cognome, $cdl){
    $db = open_pg_connection();
    $params = array($email, $password, $nome, $cognome, $cdl);
    $sql = "CALL unimia.add_student($1, $2, $3, $4, $5);";
    $result = pg_prepare($db, 'inserisci studente', $sql);
    $result = pg_execute($db, 'inserisci studente', $params);
    close_pg_connection($db);
    return $result;
}

function insert_teacher($email, $password, $nome, $cognome){
    $db = open_pg_connection();
    $params = array($email, $password, $nome, $cognome);
    $sql = "CALL unimia.add_teacher($1, $2, $3, $4);";
    $result = pg_prepare($db, 'inserisci docente', $sql);
    $result = pg_execute($db, 'inserisci docente', $params);
    close_pg_connection($db);
    return $result;
}

function insert_courses($id, $nome, $tipo, $descrizione){
    $db = open_pg_connection();
    $params = array($id, $nome, $tipo, $descrizione);
    $sql = "CALL unimia.add_cdl($1, $2, $3, $4);";
    $result = pg_prepare($db, 'inserisci corso', $sql);
    $result = pg_execute($db, 'inserisci corso', $params);
    close_pg_connection($db);
    return $result;
}

function to_pg_array($set) {
    settype($set, 'array'); 
    $result = array();
    foreach ($set as $t) {
        if (is_array($t)) {
            $result[] = to_pg_array($t);
        } else {
            $t = str_replace('"', '\\"', $t); 
            if (! is_numeric($t)) 
                $t = '"' . $t . '"';
            $result[] = $t;
        }
    }
    return '{' . implode(",", $result) . '}'; // format
}

function insert_teaching($id, $nome, $descrizione, $anno, $cfu, $corso, $docente, $insegnamenti_propedeutici){
    $db = open_pg_connection();
    $params = array();
    if (!$insegnamenti_propedeutici){
        // array vuoto
        $params = array($id, $nome, $descrizione, $anno, $cfu, $corso, $docente);
        $sql = "CALL unimia.add_insegnamento($1, $2, $3, $4, $5::smallint, $6, $7, NULL);";
        $result = pg_prepare($db, 'inserisci insegnamento', $sql);
        $result = pg_execute($db, 'inserisci insegnamento', $params);
        close_pg_connection($db);
        return $result;
    }else{
        // array con valori
        $params = array($id, $nome, $descrizione, $anno, $cfu, $corso, $docente, to_pg_array($insegnamenti_propedeutici));
        $sql = "CALL unimia.add_insegnamento($1, $2, $3, $4, $5::smallint, $6, $7, $8);";
        $result = pg_prepare($db, 'inserisci insegnamento', $sql);
        $result = pg_execute($db, 'inserisci insegnamento', $params);
        close_pg_connection($db);
        return $result;
    }
}

function insert_appello($id, $data, $orario, $luogo){
    $db = open_pg_connection();
    $params = array($id, $data, $orario, $luogo);
    $sql = "CALL unimia.add_appello($1, $2, $3, $4);";
    $result = pg_prepare($db, 'inserisci corso', $sql);
    $result = pg_execute($db, 'inserisci corso', $params);
    close_pg_connection($db);
    return $result;
}

function insert_voto($id_appello, $id_studente, $voto){
    $db = open_pg_connection();
    $params = array($id_appello, $id_studente, $voto);
    $sql = "CALL unimia.add_valutazione_esame($1, $2, $3);";
    $result = pg_prepare($db, 'inserisci voto', $sql);
    $result = pg_execute($db, 'inserisci voto', $params);
    close_pg_connection($db);
    return $result;
}

function is_docente_responsabile($id_docente, $id_insegnamento){
    $db = open_pg_connection();
    $params = array($id_docente, $id_insegnamento);
    $sql = "
        SELECT *
        FROM unimia.insegnamenti AS I
        WHERE I.id = $2 AND I.docente = $1;";
    $result = pg_prepare($db, 'controlla docente insegnamento', $sql);
    $result = pg_execute($db, 'controlla docente insegnamento', $params);
    close_pg_connection($db);
    return pg_fetch_assoc($result);
}

function studente_iscriviti_appello($appello, $studente){
    $db = open_pg_connection();
    $params = array($appello, $studente);
    $sql = "CALL unimia.add_iscrizione_studente($1, $2);";
    $result = pg_prepare($db, 'studente iscrizione', $sql);
    $result = pg_execute($db, 'studente iscrizione', $params);
    close_pg_connection($db);
    return $result;
}

function check_iscrizione($id_appello, $id_studente){
    $db = open_pg_connection();
    $params = array($id_studente, $id_appello);
    $sql = "SELECT * FROM unimia.iscrizioniesami AS I where I.studente = $1 AND I.appello = $2;";
    $result = pg_prepare($db, 'studente iscrizione', $sql);
    $result = pg_execute($db, 'studente iscrizione', $params);
    close_pg_connection($db);
    return pg_fetch_assoc($result);
}

function check_disiscrizione($id_appello, $id_studente){
    $db = open_pg_connection();
    $params = array($id_studente, $id_appello);
    $sql = "SELECT * FROM unimia.iscrizioniesami AS I 
            INNER JOIN unimia.appelli AS A ON A.id = I.appello
            WHERE I.studente = $1 AND I.appello = $2
            AND NOW() < A.data;";
    $result = pg_prepare($db, 'studente disiscrizione', $sql);
    $result = pg_execute($db, 'studente disiscrizione', $params);
    close_pg_connection($db);
    return pg_fetch_assoc($result);
}

function get_iscrizioni_studente($id_studente){
    $db = open_pg_connection();
    $params = array($id_studente);
    $sql = "SELECT * FROM unimia.get_all_iscrizioni($1);";
    $result = pg_prepare($db, 'studente iscrizioni', $sql);
    $result = pg_execute($db, 'studente iscrizioni', $params);
    close_pg_connection($db);
    
    $iscrizioni = array();
    while($row = pg_fetch_assoc($result)){
        $id = $row['_id_appello'];
        $nome_insegnamento = $row['_nome_insegnamento'];
        $data = $row['_data'];
        $orario = $row['_orario'];
        $luogo = $row['_luogo'];
        $iscrizione = array($id, $nome_insegnamento, $data, $orario, $luogo);
        array_push($iscrizioni, $iscrizione);
    }
    return $iscrizioni;

}

function get_esiti_studente($id){
    $db = open_pg_connection();
    $params = array($id);
    $sql = "SELECT * FROM unimia.get_voti_studente($1);";
    $result = pg_prepare($db, 'studente esiti', $sql);
    $result = pg_execute($db, 'studente esiti', $params);
    close_pg_connection($db);
    
    $esiti = array();
    while($row = pg_fetch_assoc($result)){
        $nome_insegnamento = $row['_nome_insegnamento'];
        $data = $row['_data'];
        $voto = $row['_voto'];
        $esito = array($nome_insegnamento, $data, $voto);
        array_push($esiti, $esito);
    }
    return $esiti;

}
/**
 * Resituisce gli esami che il docente puo' valutare
 */
function get_esami_valutare_docente($id){
    $db = open_pg_connection();
    $params = array($id);
    $sql = "SELECT * FROM unimia.get_esami_valutare_docente($1);";
    $result = pg_prepare($db, 'valuta studente', $sql);
    $result = pg_execute($db, 'valuta studente', $params);
    close_pg_connection($db);
    
    $esami = array();
    while($row = pg_fetch_assoc($result)){
        $id_appello = $row['_appello'];
        $nome_insegnamento = $row['_nome_insegnamento'];
        $data = $row['_data'];
        $id_studente = $row['_studente'];
        $matricola = $row['_matricola'];
        $nome = $row['_nome'];
        $esame = array($id_appello, $nome_insegnamento, $data, $id_studente, $matricola, $nome);
        array_push($esami, $esame);
    }
    return $esami;
}

function get_carriera_valida($id_studente){
    $db = open_pg_connection();
    $params = array($id_studente);
    $sql = "SELECT * FROM unimia.get_carriera_valida_studente($1);";
    $result = pg_prepare($db, 'studente esiti', $sql);
    $result = pg_execute($db, 'studente esiti', $params);
    close_pg_connection($db);
    
    $esiti = array();
    while($row = pg_fetch_assoc($result)){
        $id_insegnamento = $row['_id_insegnamento'];
        $nome_insegnamento = $row['_nome_insegnamento'];
        $data = $row['_data'];
        $voto = $row['_voto'];
        $esito = array($id_insegnamento, $nome_insegnamento, $data, $voto);
        array_push($esiti, $esito);
    }
    return $esiti;
}

function remove_student($id, $motivazione){
    $db = open_pg_connection();
    $params = array($motivazione, $id);
    $sql = "CALL unimia.archivia_studente($1, $2);";
    $result = pg_prepare($db, 'rimuovi studente', $sql);
    $result = pg_execute($db, 'rimuovi studente', $params);
    close_pg_connection($db);
    return $result;
}

function remove_teacher($id){
    $db = open_pg_connection();
    $params = array($id);
    $sql = "CALL unimia.delete_docente($1);";
    $result = pg_prepare($db, 'rimuovi docente', $sql);
    $result = pg_execute($db, 'rimuovi docente', $params);
    close_pg_connection($db);
    return $result;
}

function remove_iscrizione_esame($id_appello, $id_studente){
    $db = open_pg_connection();
    $params = array($id_studente, $id_appello);
    $sql = "CALL unimia.disiscriviti_studente($1, $2);";
    $result = pg_prepare($db, 'rimuovi iscrizione', $sql);
    $result = pg_execute($db, 'rimuovi iscrizione', $params);
    close_pg_connection($db);
    return $result;
}