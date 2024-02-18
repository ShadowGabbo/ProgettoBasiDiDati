<?php
    ini_set ("display_errors", "On");
	ini_set("error_reporting", E_ALL);
	include_once ('functions.php'); 
    session_start();

    if (isset($_POST)){
        if (!empty($_POST['id']) && !empty($_POST['tipo']) && !empty($_POST['nome']) && !empty($_POST['descrizione'])) {
            $descrizione = $_POST['descrizione'];
            $nome = $_POST['nome'];
            $tipo = $_POST['tipo'];
            $id = $_POST['id'];
            $ok = update_cdl($id, $nome, $tipo, $descrizione);
            if ($ok) {
                redirect('../segreteria/visualizzacorsi.php');
            }else{
                //$error = parseError(pg_last_error());
                redirect('../segreteria/visualizzacorsi.php');
            }
        }else{
            redirect('../segreteria/visualizzacorsi.php');
        }
    }