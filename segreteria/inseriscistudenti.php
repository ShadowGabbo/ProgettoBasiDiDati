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
    <title>Inserisci studenti</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">

  </head>
  <body>
  <div class="container-fluid">
    <?php include_once("navbar.php"); ?>

    <?php
        if (isset($_SESSION['insert_studente'])){
            if ($_SESSION['insert_studente'] == false){
                ?>
                    <div class="alert alert-danger" role="alert">
                        Non e' stato inserito lo studente, informazioni errate, riprovare
                    </div>
                <?php
            }else{
                ?>
                    <div class="alert alert-success" role="alert">
                        Inserito correttamente lo studente nel db
                    </div>
                <?php
            }
        }
    ?>

    <h1>Inserisci studenti</h1>
    <form method="POST" action="../lib/aggiungistudente.php">
    <div class="mb-3">
        <label for="exampleInputEmail1" class="form-label">Email</label>
        <input placeholder="nomecognome@studente.it" type="text" class="form-control" id="exampleInputEmail1" aria-describedby="emailHelp" name="email">
    </div>
    <div class="mb-3">
        <label for="exampleInputPassword1" class="form-label">Password</label>
        <input placeholder="almeno di 4 elementi" type="password" class="form-control" id="exampleInputPassword1" name="password">
    </div>
    <div class="mb-3">
        <label for="exampleInputEmail1" class="form-label">Nome</label>
        <input type="text" class="form-control" id="exampleInputEmail1" aria-describedby="emailHelp" name="nome">
    </div>
    <div class="mb-3">
        <label for="exampleInputEmail1" class="form-label">Cognome</label>
        <input type="text" class="form-control" id="exampleInputEmail1" aria-describedby="emailHelp" name="cognome">
    </div>
    <div class="mb-3">
        <label for="exampleInputEmail1" class="form-label">Codice corso di laurea</label>
        <input placeholder="codice di massimo 6 cifre/lettere" type="text" class="form-control" id="exampleInputEmail1" aria-describedby="emailHelp" name="cdl">
    </div>
    <button type="submit" class="btn btn-primary">Inserisci studente</button>
    </form>
  </body>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
</html>