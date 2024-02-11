<?php
    ini_set ("display_errors", "On");
	ini_set("error_reporting", E_ALL);
	include_once ('functions.php'); 

    
    if (isset($_POST)){
        if (!empty($_POST['usr']) && !empty($_POST['psw']) && !empty($_POST['tipo'])) {
            print('Controllo il login...' . $_POST['tipo']);
            $email = $_POST['usr'];
            $psw = $_POST['psw'];
            $tipo = $_POST['tipo'];
            $ok = check_login($email, $psw, $tipo);
            if ($ok) {
                redirect('');
            }
        }else{
            print('I campi non possono essere vuoti');
        }
    }