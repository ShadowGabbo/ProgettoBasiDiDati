<?php
    ini_set ("display_errors", "On");
	ini_set("error_reporting", E_ALL);
	include_once ('functions.php'); 
    session_start();

    if (isset($_POST)){
        if (!empty($_POST['id']) && !empty($_POST['nome']) && !empty($_POST['corso']) && !empty($_POST['descrizione']) && !empty($_POST['anno']) && !empty($_POST['cfu']) && !empty($_POST['docente'])) {
            $id = $_POST['id'];
            $nome = $_POST['nome'];
            $corso = $_POST['corso'];
            $descrizione = $_POST['descrizione'];
            $anno = $_POST['anno'];
            $cfu = $_POST['cfu'];
            $docente = $_POST['docente'];
            $ok = update_insegnamento($id, $nome, $descrizione, $anno, $cfu, $corso, $docente);
            if ($ok) {
                redirect('../segreteria/visualizzainsegnamenti.php');
            }else{
                //$error = parseError(pg_last_error());
                redirect('../segreteria/visualizzainsegnamenti.php');
            }
        }else{
            redirect('../segreteria/visualizzainsegnamenti.php');
        }
    }