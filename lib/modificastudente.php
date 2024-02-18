<?php
    ini_set ("display_errors", "On");
	ini_set("error_reporting", E_ALL);
	include_once ('functions.php'); 
    session_start();

    if (isset($_POST)){
        if (!empty($_POST['id']) && !empty($_POST['email']) && !empty($_POST['matricola']) && !empty($_POST['nome']) && !empty($_POST['cognome']) && !empty($_POST['cdl'])) {
            $email = $_POST['email'];
            $matricola = $_POST['matricola'];
            $nome = $_POST['nome'];
            $cognome = $_POST['cognome'];
            $cdl = $_POST['cdl'];
            $id = $_POST['id'];
            $ok = update_student($id, $nome, $cognome, $email, $matricola, $cdl);
            if ($ok) {
                redirect('../segreteria/visualizzastudenti.php');
            }else{
                redirect('../segreteria/visualizzastudenti.php');
            }
        }else{
            redirect('../segreteria/visualizzastudenti.php');
        }
    }