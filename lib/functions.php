<?php
/**
 * Fa i redirect tra le pagine php
 */
function redirect($url, $permanent = false) {
    header("Location: $url", true, $permanent ? 301 : 302);
    exit();
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