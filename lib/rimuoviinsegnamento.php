<?php
    ini_set ("display_errors", "On");
	ini_set("error_reporting", E_ALL);
	include_once ('functions.php'); 
    session_start();

    if (isset($_GET)){
        if (!empty($_GET['id'])) {
            $id = $_GET['id'];
            $ok = remove_insegnamento($id);
            if ($ok) {
                $_SESSION['remove_insegnamento'] = true;
                redirect('../segreteria/visualizzainsegnamenti.php');
            }else{
                $_SESSION['remove_insegnamento'] = false;
                //$error = parseError(pg_last_error());
                redirect('../segreteria/visualizzainsegnamenti.php');
                }
        }else{
            $_SESSION['remove_insegnamento'] = false;
            redirect('../segreteria/visualizzainsegnamenti.php');
        }
    }