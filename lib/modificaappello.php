<?php
    ini_set ("display_errors", "On");
	ini_set("error_reporting", E_ALL);
	include_once ('functions.php'); 
    session_start();

    if (isset($_POST)){
        if (!empty($_POST['id']) && !empty($_POST['tipo']) && !empty($_POST['nome']) && !empty($_POST['descrizione'])) {
            $orario = $_POST['orario'];
            $luogo = $_POST['luogo'];
            $data = $_POST['data'];
            $id = $_POST['id'];
            $insegnamento = $_POST['insegnamento'];
            $ok = update_appello($id, $data, $orario, $luogo, $insegnamento);
            if ($ok) {
                redirect('../docente/calendarioesami.php');
            }else{
                $error = parseError(pg_last_error());
                redirect('../docente/calendarioesami.php');
            }
        }else{
            redirect('../docente/calendarioesami.php');
        }
    }