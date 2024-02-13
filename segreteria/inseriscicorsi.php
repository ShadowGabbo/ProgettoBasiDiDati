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
    <title>Inserisci docenti</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">

  </head>
  <body>
  <div class="container-fluid">
    <?php include_once("navbar.php"); ?>

    <?php
        if (isset($_SESSION['insert_corso'])){
            if ($_SESSION['insert_corso'] == false){
                ?>
                    <div class="alert alert-danger" role="alert">
                        Non e' stato inserito il corso, informazioni errate, riprovare
                    </div>
                <?php
            }else{
                ?>
                    <div class="alert alert-success" role="alert">
                        Inserito correttamente il corso nel db
                    </div>
                <?php
            }
        }
    ?>

    <h1>Inserisci nuovo corso di laurea o cdl</h1>
    <form method="POST" action="../lib/aggiungicorso.php">
    <div class="mb-3">
        <label for="exampleInputEmail1" class="form-label">Id corso</label>
        <input placeholder="Id corso massimo 6 caratteri" type="text" class="form-control" id="exampleInputEmail1" aria-describedby="emailHelp" name="id">
    </div>
    <div class="mb-3">
        <label for="exampleInputPassword1" class="form-label">Nome</label>
        <input placeholder="nome del corso" type="text" class="form-control" id="exampleInputPassword1" name="nome">
    </div>
    <div class="mb-3">
        <label for="exampleInputPassword1" class="form-label">Tipo corso</label>
        <select class="form-select" aria-label="Default select example" name="tipo">
            <option selected value="triennale">triennale</option>
            <option value="magistrale">magistrale</option>
            <option value="magistrale a ciclo unico">magistrale a ciclo unico</option>
        </select>
    </div>
    <div class="mb-3">
        <label for="exampleInputEmail1" class="form-label">Descrizione</label>
        <input placeholder="una breve descrizione del corso" type="text" class="form-control" id="exampleInputEmail1" aria-describedby="emailHelp" name="descrizione">
    </div>
    <button type="submit" class="btn btn-primary">Inserisci corso</button>
    </form>
  </body>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
</html>