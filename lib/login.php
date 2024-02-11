<?php
    ini_set ("display_errors", "On");
	ini_set("error_reporting", E_ALL);
	include_once ('functions.php'); 
    session_start();

    if (isset($_POST)){
        if (!empty($_POST['usr']) && !empty($_POST['psw']) && !empty($_POST['tipo'])) {
            $email = $_POST['usr'];
            $psw = $_POST['psw'];
            $tipo = $_POST['tipo'];
            $ok = check_login($email, $psw, $tipo);
            $_SESSION['feedback'] = $ok;
            if ($ok) {
                switch ($tipo) {
                    case 'studente':
                        redirect('../studente/home.php');
                        break;
                    case 'docente':
                        redirect('../docente/home.php');
                        break;
                    case 'segretario':
                        redirect('../segreteria/home.php');
                        break;
                    default:
                        redirect('../index.php');
                        break;
                }
            }else{
                redirect('../index.php');
            }
        }else{
            print('I campi non possono essere vuoti');
        }
    }