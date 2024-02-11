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
 */
function check_login($usr, $psw, $tipo){
    $db = open_pg_connection();
    $params = array($usr, $psw, $tipo); 
    $sql = 
        "SELECT * FROM unimia.utenti AS U
         WHERE U.email = $1 AND U.password = $2 AND U.tipo = $3";
    $result = pg_prepare($db, 'login', $sql);
    $result = pg_execute($db, 'login', $params);
    close_pg_connection($db);

    if (pg_fetch_assoc($result)) return true; // trovato il record
    else return false;
}