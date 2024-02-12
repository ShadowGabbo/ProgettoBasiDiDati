<?php
    ini_set ("display_errors", "On");
	ini_set("error_reporting", E_ALL);
	include_once ('functions.php'); 
    session_start();

    if (isset($_POST)){
        if (!empty($_POST['password']) && strlen($_POST['password'] > 3)) {
            // cambio password
            $ok = change_password($_SESSION['id'], $_POST['password']);
            if ($ok) {
                redirect('../index.php');
            }else{
                $_SESSION['flag'] = false;
                redirect('../studente/cambiapassword.php');
            }
        }else{
            $_SESSION['flag'] = false;
            redirect('../studente/cambiapassword.php');
        }
    }