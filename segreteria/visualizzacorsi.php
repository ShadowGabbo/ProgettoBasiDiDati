<?php
    ini_set ("display_errors", "On");
	ini_set("error_reporting", E_ALL);
    include_once ('../lib/functions.php'); 
    session_start();

    if (!isset($_SESSION['id'])){
        redirect('../index.php');
    }

    $corsi = get_courses();
?>
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Visualizza corsi</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">

  </head>
  <body>
  <div class="container-fluid">
    <?php include_once("navbar.php"); ?>
    <h1>Visualizza corsi di laurea (cdl)</h1>
    <table class="table table-dark table-striped">
        <thead>
            <tr>
            <th scope="col">ID</th>
            <th scope="col">Nome</th>
            <th scope="col">Tipo</th>
            <th scope="col">Descrizione</th>
        </tr>
    </thead>
    <tbody>
        <?php foreach ($corsi as $corso) {?>
            <tr>
                <td><?php print($corso[0]) ?></td>
                <td><?php print($corso[1]) ?></td>
                <td><?php print($corso[2]) ?></td>
                <td><?php print($corso[3]) ?></td>
            </tr>
        <?php } ?>
    </table>

  </body>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
</html>