<?php
    ini_set ("display_errors", "On");
	ini_set("error_reporting", E_ALL);
	include_once ('functions.php'); 
    session_start();

    if (isset($_GET)){
        if (!empty($_GET['id']) && !empty($_SESSION['id'])) {
            $id_appello = $_GET['id'];
            $id_studente = $_SESSION['id'];
            $ok = remove_iscrizione_esame($id_appello, $id_studente);
            if ($ok) {
                $_SESSION['remove_iscrizione'] = true;
                redirect('../studente/iscrizioniconfermate.php');
            }else{
                $_SESSION['remove_iscrizione'] = false;
                $error = parseError(pg_last_error());
                redirect('../studente/iscrizioniconfermate.php');
                }
        }else{
            $_SESSION['remove_iscrizione'] = false;
            redirect('../studente/iscrizioniconfermate.php');
        }
    }