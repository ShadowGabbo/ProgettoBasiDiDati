<?php
    ini_set ("display_errors", "On");
	ini_set("error_reporting", E_ALL);
    include_once ('../lib/functions.php'); 
    session_start();

    if (!isset($_SESSION['id'])){
        redirect('../index.php');
    }

    $appelli = calendario_docente($_SESSION['id']);
    //print_r($appelli);
?>
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Calendario esami</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">

  </head>
  <body>
  <div class="container-fluid">
    <?php include_once("navbar.php"); ?>
    <?php if (isset($appelli)){ ?>
        <h2>Visualizza tutti gli appelli per i suoi insegnamenti</h2>
        <table class="table table-dark table-striped">
        <thead>
            <tr>
            <th scope="col">Id</th>
            <th scope="col">Nome insegnamento</th>
            <th scope="col">Nome Corso</th>
            <th scope="col">Data</th>
            <th scope="col">Orario</th>
            <th scope="col">Luogo</th>
            <th scope="col">Elimina appello</th>
            <th scope="col">Modifica appello</th>
        </tr>
    </thead>
    <tbody>
        <?php foreach ($appelli as $appello) {?>
            <tr>
                <td><?php print($appello[0]) ?></td>
                <td><?php print($appello[1]) ?></td>
                <td><?php print($appello[2]) ?></td>
                <td><?php print($appello[3]) ?></td>
                <td><?php print($appello[4]) ?></td>
                <td><?php print($appello[5]) ?></td>
                <form action='../lib/rimuoviappello.php' method='get'>
                    <input type='hidden' name="id" value='<?php echo $appello[0]; ?>'>
                    <td><button type="submit" class="btn btn-danger">Elimina</button></td>
                </form>
                <td>
                <form action='modificaappello.php' method='POST'>
                    <input type='hidden' name="id_appello" value='<?php echo $appello[0];?>'>
                    <button type="submit" class="btn btn-primary">Modifica appello</button>
                </form>
                </td>
            </tr>
        <?php } ?>
    </table>
    <?php } ?>
  </body>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
</html>