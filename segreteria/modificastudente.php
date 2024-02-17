<?php
    ini_set ("display_errors", "On");
	ini_set("error_reporting", E_ALL);
	include_once ('../lib/functions.php'); 
    session_start();

    if (isset($_POST)){
        if (!empty($_POST['id_studente'])) {
            $studente_id = $_POST['id_studente'];
            $arr = get_student($studente_id);
        }
    }
?>
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Visualizza studenti</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">

  </head>
  <body>
  <div class="container-fluid">
    <?php include_once("navbar.php"); ?>
    <?php
        if (isset($_SESSION['remove_student'])){
            if ($_SESSION['remove_student'] == false){
                ?>
                    <div class="alert alert-danger" role="alert">
                        Problema con l'archiviazione dello studente
                    </div>
                <?php
            }else{
                ?>
                    <div class="alert alert-success" role="alert">
                        Archiviato studente con successo
                    </div>
                <?php
            }
        }
    ?>

    <h1>Modifica studenti</h1>
    </body>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
</html>