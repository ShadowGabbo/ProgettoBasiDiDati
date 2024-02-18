<?php
    ini_set ("display_errors", "On");
	ini_set("error_reporting", E_ALL);
	include_once ('functions.php'); 
    session_start();

    if (isset($_GET)){
        if (!empty($_GET['id'])) {
            $id = $_GET['id'];
            $motivazione = $_GET['motivazione'];
            $ok = remove_student($id, $motivazione);
            print($motivazione.' '.$id);
            if ($ok) {
                $_SESSION['remove_student'] = true;
                redirect('../segreteria/visualizzastudenti.php');
            }else{
                $_SESSION['remove_student'] = false;
                //$error = parseError(pg_last_error());
                redirect('../segreteria/visualizzastudenti.php');
                }
        }else{
            $_SESSION['remove_student'] = false;
            redirect('../segreteria/visualizzastudenti.php');
        }
    }