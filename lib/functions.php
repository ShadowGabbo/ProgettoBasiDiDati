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
