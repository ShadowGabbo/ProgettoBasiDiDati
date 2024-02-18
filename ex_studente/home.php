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
    <title>Profilo Ex-studente</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
    <link rel="stylesheet" href="../css/esami.css">
  </head>
  <body>
  <div class="container-fluid">
    <br>
    <div class="row">
        <div class="col-12">
            <div class="card-body">
                <a href="carrieracompleta.php"><h2 class="card-text">Carriera completa ex-studente</h2></a>
                <p>Gli esiti di tutti gli esami sostenuti</p>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-12">
            <div class="card-body">
                <a href="carrieravalida.php"><h2 class="card-text">Carriera valida ex-studente</h2></a>
                <p>Gli esiti di tutti gli esami recenti superati </p>
            </div>
        </div>
    </div>
  </body>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
</html>