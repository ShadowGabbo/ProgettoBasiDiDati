<?php
    ini_set ("display_errors", "On");
	ini_set("error_reporting", E_ALL);
    include_once ('../lib/functions.php'); 
    session_start();

    if (!isset($_SESSION['id'])){
        redirect('../index.php');
    }
?>
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Inserisci appello</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">

  </head>
  <body>
  <div class="container-fluid">
    <?php include_once("navbar.php"); ?>

    <?php
        if (isset($_SESSION['insert_appello'])){
            if ($_SESSION['insert_appello'] == false){
                ?>
                    <div class="alert alert-danger" role="alert">
                        Non e' stato inserito l'appelllo, informazioni errate, riprovare
                    </div>
                <?php
            }else{
                ?>
                    <div class="alert alert-success" role="alert">
                        Inserito correttamente l'appello nel db
                    </div>
                <?php
            }
        }
    ?>

    <h1>Inserisci appello</h1>
    <form method="POST" action="../lib/aggiungiappello.php">
    <div class="mb-3">
        <label for="exampleInputEmail1" class="form-label">Codice insegnamento</label>
        <input placeholder="Massimo 6 caratteri" type="text" class="form-control" id="exampleInputEmail1" aria-describedby="emailHelp" name="id">
    </div>
    <div class="mb-3">
        <label for="exampleInputPassword1" class="form-label">Data</label>
        <input placeholder="Deve essere del formato <yyyy-mm-dd>" type="password" class="form-control" id="exampleInputPassword1" name="data">
    </div>
    <div class="mb-3">
        <label for="exampleInputEmail1" class="form-label">Orario</label>
        <input placeholder="Deve essere del formato <hh:mm:ss>" type="text" class="form-control" id="exampleInputEmail1" aria-describedby="emailHelp" name="orario">
    </div>
    <div class="mb-3">
        <label for="exampleInputEmail1" class="form-label">Luogo</label>
        <input placeholder="Specificare via e civico almeno"type="text" class="form-control" id="exampleInputEmail1" aria-describedby="emailHelp" name="cognome">
    </div>
    <button type="submit" class="btn btn-primary">Inserisci appello</button>
    </form>
  </body>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
</html>