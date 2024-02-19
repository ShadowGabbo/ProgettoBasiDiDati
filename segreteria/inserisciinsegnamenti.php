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
    <title>Inserisci insegnamenti</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">

  </head>
  <body>
  <div class="container-fluid">
    <?php include_once("navbar.php"); ?>

    <?php
        if (isset($_SESSION['insert_teaching'])){
            if ($_SESSION['insert_teaching'] == false){
                ?>
                    <div class="alert alert-danger" role="alert">
                        Non e' stato inserito l'insegnamento, informazioni errate, riprovare
                    </div>
                <?php
            }else{
                ?>
                    <div class="alert alert-success" role="alert">
                        Inserito correttamente l'insegnamento nel db
                    </div>
                <?php
            }
        }
    ?>

    <h1>Inserisci insegnamento</h1>
    <form method="POST" action="../lib/aggiungiinsegnamento.php">
    <div class="mb-3">
        <label for="exampleInputEmail1" class="form-label">Id</label>
        <input placeholder="Codice di max 6 caratteri" type="text" class="form-control" id="exampleInputEmail1" aria-describedby="emailHelp" name="id">
    </div>
    <div class="mb-3">
        <label for="exampleInputPassword1" class="form-label">Nome</label>
        <input placeholder="Nome insegnamento" type="text" class="form-control" id="exampleInputPassword1" name="nome">
    </div>
    <div class="mb-3">
        <label for="exampleInputEmail1" class="form-label">Descrizione</label>
        <input placeholder="Descrizione dell'insegnamento" type="text" class="form-control" id="exampleInputEmail1" aria-describedby="emailHelp" name="descrizione">
    </div>
    <div class="mb-3">
        <label for="exampleInputEmail1" class="form-label">Anno erogazione</label>
        <select class="form-select" aria-label="Default select example" name="anno">
            <option selected value="1">1</option>
            <option value="2">2</option>
            <option value="3">3</option>
            <option value="4">4</option>
            <option value="5">5</option>
        </select>
    </div>
    <div class="mb-3">
        <label for="exampleInputEmail1" class="form-label">Cfu</label>
        <select class="form-select" aria-label="Default select example" name="cfu">
            <option selected value="3">3</option>
            <option value="6">6</option>
            <option value="9">9</option>
            <option value="12">12</option>
            <option value="15">15</option>
        </select>
    </div>
    <div class="mb-3">
        <label for="exampleInputEmail1" class="form-label">Codice corso di laurea</label>
        <input placeholder="Massimo 6 caratteri" type="text" class="form-control" id="exampleInputEmail1" aria-describedby="emailHelp" name="corso">
    </div>
    <div class="mb-3">
        <label for="exampleInputEmail1" class="form-label">Docente responsabile</label>
        <input placeholder="Inserire uuid" type="text" class="form-control" id="exampleInputEmail1" aria-describedby="emailHelp" name="docente">
    </div>
    <div class="mb-3">
        <label for="exampleInputEmail1" class="form-label">Insegnamento/i propedeutico/i</label>
        <input placeholder="<codice1> <codice2> (se non ne ha lasciare vuoto)" type="text" class="form-control" id="exampleInputEmail1" aria-describedby="emailHelp" name="propedeutici">
    </div>
    <button type="submit" class="btn btn-primary">Inserisci insegnamento</button>
    </form>
  </body>
  <?php 
    // unset variabili inutili
    unset($_SESSION['insert_teaching']);
    ?>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
</html>