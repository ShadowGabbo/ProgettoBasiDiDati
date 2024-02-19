<?php
    ini_set ("display_errors", "On");
	ini_set("error_reporting", E_ALL);
    include_once ('../lib/functions.php'); 
    session_start();

    if (!isset($_SESSION['id'])){
        redirect('../index.php');
    }

    $iscrizioni = get_iscrizioni_studente($_SESSION['id']);
?>
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Visualizza appelli confermati</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">

  </head>
  <body>
  <div class="container-fluid">
    <?php include_once("navbar.php"); ?>
    <?php
        if (isset($_SESSION['remove_iscrizione'])){
            if ($_SESSION['remove_iscrizione'] == false){
                ?>
                    <div class="alert alert-danger" role="alert">
                        Errore durante la disiscrizione
                    </div>
                <?php
            }else{
                ?>
                    <div class="alert alert-success" role="alert">
                        Disiscrizione all'esame avvenuta con successo
                    </div>
                <?php
            }
        }
    ?>

    <?php if (isset($iscrizioni)){ ?>
        <h3>Di seguito sono mostrate le iscrizioni effettuate per gli esami</h3>
        <br>
        <?php if (isset($iscrizioni)){ ?>
        <h3>Iscrizioni agli esami</h3>
        <table class="table table-dark table-striped">
        <thead>
            <tr>
            <th scope="col">Id appello</th>
            <th scope="col">Nome insegnamento</th>
            <th scope="col">Data</th>
            <th scope="col">Orario</th>
            <th scope="col">Luogo</th>
            <th scope="col">Disiscriviti</th>
        </tr>
    </thead>
    <tbody>
        <?php foreach ($iscrizioni as $iscrizione) {?>
            <tr>
                <td><?php print($iscrizione[0]) ?></td>
                <td><?php print($iscrizione[1]) ?></td>
                <td><?php print($iscrizione[2]) ?></td>
                <td><?php print($iscrizione[3]) ?></td>
                <td><?php print($iscrizione[4]) ?></td>

                <?php if (!check_disiscrizione($iscrizione[0], $_SESSION['id'])){ ?>
                    <td><button type="submit" class="btn btn-success disabled">Gia sostenuto</button></td>
                <?php }else{?>
                    <form action='../lib/disiscrivitiappello.php' method='get'>
                    <input type='hidden' name="id" value='<?php echo $iscrizione[0]; ?>'>
                    <td><button type="submit" class="btn btn-danger">Disiscriviti</button></td>
                </form>
                <?php }?>
            </tr>
        <?php } ?>
    </table>
    <?php } ?>
    <?php } ?>

    <?php 
    // unset variabili inutili
    unset($_SESSION['remove_iscrizione']);
    ?>
  </body>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
</html>