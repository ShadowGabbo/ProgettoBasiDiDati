<?php
    ini_set ("display_errors", "On");
	ini_set("error_reporting", E_ALL);
    include_once ('../lib/functions.php'); 
    include_once("navbar.php");
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
    <title>Profilo Studente</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
    <link rel="stylesheet" href="../css/esami.css">
  </head>
  <body>
  <div class="container-fluid">
    <br>
    <div class="row">
        <div class="col-12">
            <div class="card-body">
                <a href="esiti.php"><h2 class="card-text">Esiti esami</h2></a>
                <p>Gli esiti di tutti gli esami sostenuti</p>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-12">
            <div class="card-body">
                <a href="iscrizioniconfermate.php"><h2 class="card-text">Iscrizioni confermate agli esami</h2></a>
                <p>Tutte le iscrizioni confermate del proprio corso di studi</p>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-12">
            <div class="card-body">
                <a href="nuoveiscrizioni.php"><h2 class="card-text">Iscrizioni per un nuovo esame</h2></a>
                <p>Iscriviti ad un nuovo esami del tuo corso di studi</p>
            </div>
        </div>
    </div>
  </body>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
</html>