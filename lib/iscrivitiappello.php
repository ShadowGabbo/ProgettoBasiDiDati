<?php
    ini_set ("display_errors", "On");
	ini_set("error_reporting", E_ALL);
	include_once ('functions.php'); 
    session_start();

    if (isset($_GET)){
        if (!empty($_GET['id']) && !empty($_SESSION['id'])) {
            $appello_id = $_GET['id'];
            $studente_id = $_SESSION['id'];
            //print($appello_id.' '.$studente_id);

            $ok = studente_iscriviti_appello($appello_id, $studente_id);
            if ($ok) {
                $_SESSION['iscriviti'] = true;
                //$error = parseError(pg_last_error());
                redirect('../studente/iscrivitiappelli.php');
            }else{
                $_SESSION['iscriviti'] = false;
                //$error = parseError(pg_last_error());
                redirect('../studente/iscrivitiappelli.php');
            }
        }else{
            $_SESSION['iscriviti'] = false;
            //$error = parseError(pg_last_error());
            redirect('../studente/iscrivitiappelli.php');
        }
    }