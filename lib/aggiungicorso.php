<?php
    ini_set ("display_errors", "On");
	ini_set("error_reporting", E_ALL);
	include_once ('functions.php'); 
    session_start();

    if (isset($_POST)){
        if (!empty($_POST['id']) && !empty($_POST['nome']) && !empty($_POST['tipo']) && !empty($_POST['descrizione'])) {
            // cambio password
            $id = $_POST['id'];
            $tipo = $_POST['tipo'];
            $nome = $_POST['nome'];
            $descrizione = $_POST['descrizione'];
            $ok = insert_courses($id, $nome, $tipo, $descrizione);
            if ($ok) {
                $_SESSION['insert_corso'] = true;
                redirect('../segreteria/inseriscicorsi.php');
            }else{
                $_SESSION['insert_corso'] = false;
                redirect('../segreteria/inseriscicorsi.php');
            }
        }else{
            $_SESSION['insert_corso'] = false;
            redirect('../segreteria/inseriscicorsi.php');
        }
    }