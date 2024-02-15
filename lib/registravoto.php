<?php
    ini_set ("display_errors", "On");
	ini_set("error_reporting", E_ALL);
	include_once ('functions.php'); 
    session_start();

    if (isset($_POST)){
        if (!empty($_POST['id_appello']) && !empty($_POST['id_studente']) && !empty($_POST['voto'])) {
            $id_appello = $_POST['id_appello'];
            $id_studente = $_POST['id_studente'];
            $voto = $_POST['voto'];
            $ok = insert_voto($id_appello, $id_studente, $voto);
            if ($ok) {
                $_SESSION['insert_voto'] = true;
                redirect('../docente/registraesiti.php');
            }else{
                $_SESSION['insert_voto'] = false;
                redirect('../docente/registraesiti.php');
            }
        }else{
            $_SESSION['insert_voto'] = false;
            redirect('../docente/registraesiti.php');
        }
    }