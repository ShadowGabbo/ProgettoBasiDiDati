<?php
    ini_set ("display_errors", "On");
	ini_set("error_reporting", E_ALL);
    include_once ('../lib/functions.php'); 
    session_start();

    if (!isset($_SESSION['id'])){
        redirect('../index.php');
    }

    $students = get_students();
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
        if (isset($_SESSION['remove_student'])){
            if ($_SESSION['remove_student'] == false){
                ?>
                    <div class="alert alert-danger" role="alert">
                        Problema con l'archiviazione dello studente
                    </div>
                <?php
            }else{
                ?>
                    <div class="alert alert-success" role="alert">
                        Archiviato studente con successo
                    </div>
                <?php
            }
        }
    ?>

    <h1>Visualizza studenti</h1>
    <table class="table table-dark table-striped">
        <thead>
            <tr>
            <th scope="col">ID</th>
            <th scope="col">Nome</th>
            <th scope="col">Cognome</th>
            <th scope="col">Email</th>
            <th scope="col">Matricola</th>
            <th scope="col">Corso di Laurea</th>
            <th scope="col">Elimina studente</th>
        </tr>
    </thead>
    <tbody>
        <?php foreach ($students as $student) {?>
            <tr>
                <?php $id = $student ?>
                <td><?php 
                    $id = $student[0];
                    print($student[0]) ?></td>
                <td><?php print($student[1]) ?></td>
                <td><?php print($student[2]) ?></td>
                <td><?php print($student[3]) ?></td>
                <td><?php print($student[4]) ?></td>
                <td><?php print($student[5]) ?></td>
                <td>
                <div class="dropdown">
                    <button class="btn btn-danger dropdown-toggle" type="button" id="dropdownMenuButton1" data-bs-toggle="dropdown" aria-expanded="false">
                        Elimina
                    </button>
                    <ul class="dropdown-menu" aria-labelledby="dropdownMenuButton1">
                            <li><a class="dropdown-item" href='../lib/rimuovistudente.php?id=<?php echo $id?>&motivazione=rinuncia'>Rinuncia</a></li>
                            <li><a class="dropdown-item" href='../lib/rimuovistudente.php?id=<?php echo $id?>&motivazione=laurea'>Laurea</a></li>
                    </ul>
                    </div>
                </td>
            </tr>
        <?php } ?>
    </table>

  </body>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
</html>