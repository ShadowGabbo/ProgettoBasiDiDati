<?php
    ini_set ("display_errors", "On");
	ini_set("error_reporting", E_ALL);
    include_once ('../lib/functions.php'); 
    session_start();

    if (!isset($_SESSION['id'])){
        redirect('../index.php');
    }

    $esiti = get_esiti_studente($_SESSION['id']);
?>
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Visualizza esiti esame</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">

  </head>
  <body>
  <div class="container-fluid">
    <?php include_once("navbar.php"); ?>

    <?php if (isset($esiti)){ ?>
        <h3>Di seguito sono mostrati i voti degli esami sostenuti</h3>
        <br>
        <h3>Voti esami</h3>
        <table class="table table-dark table-striped">
        <thead>
            <tr>
            <th scope="col">Nome insegnamento</th>
            <th scope="col">Data</th>
            <th scope="col">Voto</th>
        </tr>
    </thead>
    <tbody>
        <?php foreach ($esiti as $esito) {?>
            <tr>
                <td><?php print($esito[0]) ?></td>
                <td><?php print($esito[1]) ?></td>
                <td><?php print($esito[2]) ?></td>
            </tr>
        <?php } ?>
    </table>
    <?php } ?>
  </body>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
</html>