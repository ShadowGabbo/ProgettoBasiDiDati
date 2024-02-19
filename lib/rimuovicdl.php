<?php
    ini_set ("display_errors", "On");
	ini_set("error_reporting", E_ALL);
	include_once ('functions.php'); 
    session_start();

    if (isset($_GET)){
        if (!empty($_GET['id'])) {
            $id = $_GET['id'];
            $ok = remove_cdl($id);
            if ($ok) {
                $_SESSION['remove_cdl'] = true;
                redirect('../segreteria/visualizzacorsi.php');
            }else{
                $_SESSION['remove_cdl'] = false;
                //$error = parseError(pg_last_error());
                redirect('../segreteria/visualizzacorsi.php');
                }
        }else{
            $_SESSION['remove_cdl'] = false;
            redirect('../segreteria/visualizzacorsi.php');
        }
    }