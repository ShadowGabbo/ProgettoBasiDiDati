<?php
    ini_set ("display_errors", "On");
	ini_set("error_reporting", E_ALL);
	include_once ('functions.php'); 
    session_start();

    if (isset($_POST)){
        if (!empty($_POST['id']) && !empty($_SESSION['id'])) {
            $appello_id = $_POST['id'];
            $studente_id = $_SESSION['id'];

            $ok = studente_iscriviti_appello($appello_id, $studente_id);
            if ($ok) {
                $_SESSION['iscriviti'] = true;
                redirect('../studente/iscrivitiappelli.php');
            }else{
                $_SESSION['iscriviti'] = false;
                redirect('../studente/iscrivitiappelli.php');
            }
        }else{
            $_SESSION['iscriviti'] = false;
            redirect('../studente/iscrivitiappelli.php');
        }
    }