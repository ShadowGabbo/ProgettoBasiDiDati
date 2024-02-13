<?php
    ini_set ("display_errors", "On");
	ini_set("error_reporting", E_ALL);
	include_once ('functions.php'); 
    session_start();

    if (isset($_POST)){
        if (!empty($_POST['email']) && !empty($_POST['password']) && !empty($_POST['nome']) && !empty($_POST['cognome'])) {
            // cambio password
            $email = $_POST['email'];
            $password = $_POST['password'];
            $nome = $_POST['nome'];
            $cognome = $_POST['cognome'];
            $ok = insert_teacher($email, $password, $nome, $cognome);
            if ($ok) {
                $_SESSION['insert_docente'] = true;
                redirect('../segreteria/inseriscidocenti.php');
            }else{
                $_SESSION['insert_docente'] = false;
                redirect('../segreteria/inseriscidocenti.php');
            }
        }else{
            $_SESSION['insert_docente'] = false;
            redirect('../segreteria/inseriscidocenti.php');
        }
    }