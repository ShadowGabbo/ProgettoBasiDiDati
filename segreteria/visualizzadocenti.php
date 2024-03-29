<?php
    ini_set ("display_errors", "On");
	ini_set("error_reporting", E_ALL);
    include_once ('../lib/functions.php'); 
    session_start();

    if (!isset($_SESSION['id'])){
        redirect('../index.php');
    }

    $teachers = get_teachers();
?>
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Visualizza studenti</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">

  </head>
  <body>
  <div class="container-fluid">
    <?php include_once("navbar.php"); ?>
    <?php
        if (isset($_SESSION['remove_teacher'])){
            if ($_SESSION['remove_teacher'] == false){
                ?>
                    <div class="alert alert-danger" role="alert">
                        Problema con l'eliminazione del docente
                    </div>
                <?php
            }else{
                ?>
                    <div class="alert alert-success" role="alert">
                        Eliminato docente con successo
                    </div>
                <?php
            }
        }
    ?>
    <h1>Visualizza docenti</h1>
    <table class="table table-dark table-striped">
        <thead>
            <tr>
            <th scope="col">ID</th>
            <th scope="col">Nome</th>
            <th scope="col">Cognome</th>
            <th scope="col">Email</th>
            <th scope="col">Elimina docente</th>
            <th scope="col">Modifica docente</th>
        </tr>
    </thead>
    <tbody>
        <?php foreach ($teachers as $teacher) {?>
            <tr>
                <td><?php print($teacher[0]) ?></td>
                <td><?php print($teacher[1]) ?></td>
                <td><?php print($teacher[2]) ?></td>
                <td><?php print($teacher[3]) ?></td>
                <form action='../lib/rimuovidocente.php' method='get'>
                    <input type='hidden' name="id" value='<?php echo $teacher[0]; ?>'>
                    <td><button type="submit" class="btn btn-danger">Elimina</button></td>
                </form>
                <td>
                <form action='modificadocente.php' method='POST'>
                    <input type='hidden' name="id_docente" value='<?php echo $teacher[0];?>'>
                    <button type="submit" class="btn btn-primary">Modifica docente</button>
                </form>
                </td>
            </tr>
        <?php } ?>
    </table>

  </body>
  <?php 
    // unset variabili inutili
    unset($_SESSION['remove_teacher']);
    ?>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
</html>