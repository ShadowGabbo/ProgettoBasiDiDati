<?php
    ini_set ("display_errors", "On");
	ini_set("error_reporting", E_ALL);
	include_once ('functions.php'); 
    session_start();

    if (isset($_GET)){
        if (!empty($_GET['id'])) {
            $id = $_GET['id'];
            $ok = remove_appello($id);
            if ($ok) {
                $_SESSION['remove_appello'] = true;
                redirect('../docente/calendarioesami.php');
            }else{
                $_SESSION['remove_appello'] = false;
                //$error = parseError(pg_last_error());
                redirect('../docente/calendarioesami.php');
                }
        }else{
            $_SESSION['remove_appello'] = false;
            redirect('../docente/calendarioesami.php');
        }
    }