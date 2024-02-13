<?php
    ini_set ("display_errors", "On");
	ini_set("error_reporting", E_ALL);
	include_once ('functions.php'); 
    session_start();

    if (isset($_POST)){
        if (!empty($_POST['email']) && !empty($_POST['password']) && !empty($_POST['nome']) && !empty($_POST['cognome']) && !empty($_POST['cdl'])) {
            // cambio password
            $email = $_POST['email'];
            $password = $_POST['password'];
            $nome = $_POST['nome'];
            $cognome = $_POST['cognome'];
            $cdl = $_POST['cdl'];
            $ok = insert_student($email, $password, $nome, $cognome, $cdl);
            if ($ok) {
                $_SESSION['insert_studente'] = true;
                redirect('../segreteria/inseriscistudenti.php');
            }else{
                $_SESSION['insert_studente'] = false;
                redirect('../segreteria/inseriscistudenti.php');
            }
        }else{
            $_SESSION['insert_studente'] = false;
            redirect('../segreteria/inseriscistudenti.php');
        }
    }