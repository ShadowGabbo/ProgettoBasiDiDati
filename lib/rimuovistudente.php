<?php
    ini_set ("display_errors", "On");
	ini_set("error_reporting", E_ALL);
	include_once ('functions.php'); 
    session_start();

    if (isset($_GET)){
        if (!empty($_GET['id'])) {
            $id = $_GET['id'];
            print($id);
            /*
            $ok = insert_teaching($id, $nome, $descrizione, $anno, $cfu, $corso, $docente, $insegnamenti_propedeutici);
            if ($ok) {
                $_SESSION['insert_teaching'] = true;
                redirect('../segreteria/inserisciinsegnamenti.php');
            }else{
                $_SESSION['insert_teaching'] = false;
                //$error = parseError(pg_last_error());
                redirect('../segreteria/inserisciinsegnamenti.php');
                }
                */
        }else{
            $_SESSION['insert_teaching'] = false;
            redirect('../segreteria/inserisciinsegnamenti.php');
        }
    }