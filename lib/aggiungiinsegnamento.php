<?php
    ini_set ("display_errors", "On");
	ini_set("error_reporting", E_ALL);
	include_once ('functions.php'); 
    session_start();

    if (isset($_POST)){
        if (!empty($_POST['id']) && !empty($_POST['nome']) && !empty($_POST['descrizione']) && !empty($_POST['anno']) && !empty($_POST['cfu'] && !empty($_POST['corso']) && !empty($_POST['docente']))) {
            $id = $_POST['id'];
            $nome = $_POST['nome'];
            $descrizione = $_POST['descrizione'];
            $anno = $_POST['anno'];
            $cfu = $_POST['cfu'];
            $corso = $_POST['corso'];
            $docente = $_POST['docente'];
            $propedeutici = $_POST['propedeutici'];
            $insegnamenti_propedeutici = array();
            if (!empty($propedeutici)){
                $insegnamenti_propedeutici = explode(" ", $propedeutici); // split per spazio
            }
            $ok = insert_teaching($id, $nome, $descrizione, $anno, $cfu, $corso, $docente, $insegnamenti_propedeutici);
            if ($ok) {
                $_SESSION['insert_teaching'] = true;
                redirect('../segreteria/inserisciinsegnamenti.php');
            }else{
                $_SESSION['insert_teaching'] = false;
                //$error = parseError(pg_last_error());
                redirect('../segreteria/inserisciinsegnamenti.php');
            }
        }else{
            $_SESSION['insert_teaching'] = false;
            redirect('../segreteria/inserisciinsegnamenti.php');
        }
    }