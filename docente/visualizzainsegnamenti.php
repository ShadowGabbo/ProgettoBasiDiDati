<?php
    ini_set ("display_errors", "On");
	ini_set("error_reporting", E_ALL);
    include_once ('../lib/functions.php'); 
    session_start();

    if (!isset($_SESSION['id'])){
        redirect('../index.php');
    }

    $insegnamenti = get_insegnamenti_docente($_SESSION['id']);
?>
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Visualizza insegnamenti</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">

  </head>
  <body>
  <div class="container-fluid">
    <?php include_once("navbar.php"); ?>
    <?php if (isset($insegnamenti)){ ?>
        <h2>Visualizza gli insegnamenti di cui sei responsabile/insegni</h2>
        <table class="table table-dark table-striped">
        <thead>
            <tr>
            <th scope="col">ID</th>
            <th scope="col">Nome</th>
            <th scope="col">Descrizione</th>
            <th scope="col">Anno erogazione</th>
            <th scope="col">CFU</th>
            <th scope="col">Nome corso</th>
        </tr>
    </thead>
    <tbody>
        <?php foreach ($insegnamenti as $insegnamento) {?>
            <tr>
                <td><?php print($insegnamento[0]) ?></td>
                <td><?php print($insegnamento[1]) ?></td>
                <td><?php print($insegnamento[2]) ?></td>
                <td><?php print($insegnamento[3]) ?></td>
                <td><?php print($insegnamento[4]) ?></td>
                <td><?php print($insegnamento[5]) ?></td>
            </tr>
        <?php } ?>
    </table>
    <?php } ?>
  </body>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
</html>