<?php
    ini_set ("display_errors", "On");
	ini_set("error_reporting", E_ALL);
	include_once ('functions.php'); 
    session_start();

    if (isset($_POST)){
        if (!empty($_POST['id']) && !empty($_POST['email']) && !empty($_POST['nome']) && !empty($_POST['cognome'])) {
            $email = $_POST['email'];
            $nome = $_POST['nome'];
            $cognome = $_POST['cognome'];
            $id = $_POST['id'];
            $ok = update_teacher($id, $nome, $cognome, $email);
            if ($ok) {
                redirect('../segreteria/visualizzadocenti.php');
            }else{
                redirect('../segreteria/visualizzadocenti.php');
            }
        }else{
            redirect('../segreteria/visualizzadocenti.php');
        }
    }