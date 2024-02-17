<?php
    ini_set ("display_errors", "On");
	ini_set("error_reporting", E_ALL);
	include_once ('functions.php'); 
    session_start();

    if (isset($_GET)){
        if (!empty($_GET['id'])) {
            $id = $_GET['id'];
            $ok = remove_teacher($id);
            if ($ok) {
                $_SESSION['remove_teacher'] = true;
                redirect('../segreteria/visualizzadocenti.php');
            }else{
                $_SESSION['remove_teacher'] = false;
                //$error = parseError(pg_last_error());
                redirect('../segreteria/visualizzadocenti.php');
                }
        }else{
            $_SESSION['remove_teacher'] = false;
            redirect('../segreteria/visualizzadocenti.php');
        }
    }