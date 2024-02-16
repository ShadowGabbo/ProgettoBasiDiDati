<?php
    ini_set ("display_errors", "On");
	ini_set("error_reporting", E_ALL);
	include_once ('functions.php'); 
    session_start();

    if (isset($_POST)){
        if (!empty($_POST['id']) && !empty($_POST['data']) && !empty($_POST['orario']) && !empty($_POST['luogo'])) {
            // cambio password
            $id = $_POST['id'];
            $data = $_POST['data'];
            $orario = $_POST['orario'];
            $luogo = $_POST['luogo'];
            if (is_docente_responsabile($_SESSION['id'] ,$id)){
                $ok = insert_appello($id, $data, $orario, $luogo);
                if ($ok) {
                    $_SESSION['insert_appello'] = true;
                    $_SESSION['messaggio'] = 'Appello inserito correttamente';
                    redirect('../docente/inserisciappelli.php');
                }else{
                    $_SESSION['insert_appello'] = false;
                    $_SESSION['messaggio'] = 'Errore nel salvataggio del appello';
                    //$error = parseError(pg_last_error());
                    redirect('../docente/inserisciappelli.php');
                }
            }else{
                $_SESSION['insert_appello'] = false;
                $_SESSION['messaggio'] = 'Il docente non e responsabile di questo insegnamento';
                redirect('../docente/inserisciappelli.php');
            }
        }else{
            $_SESSION['insert_appello'] = false;
            $_SESSION['messaggio'] = 'Dati errati';
            redirect('../docente/inserisciappelli.php');
        }
    }