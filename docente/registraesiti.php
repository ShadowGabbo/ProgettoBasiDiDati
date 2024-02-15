<?php
    ini_set ("display_errors", "On");
	ini_set("error_reporting", E_ALL);
    include_once ('../lib/functions.php'); 
    session_start();

    if (!isset($_SESSION['id'])){
        redirect('../index.php');
    }

    $esami = get_esami_valutare_docente($_SESSION['id']);
?>
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Registra esiti</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">

  </head>
  <body>
  <div class="container-fluid">
    <?php include_once("navbar.php"); ?>
    <?php
        if (isset($_SESSION['insert_voto'])){
            if ($_SESSION['insert_voto'] == false){
                ?>
                    <div class="alert alert-danger" role="alert">
                        Errore, voto non inserito
                    </div>
                <?php
            }else{
                ?>
                    <div class="alert alert-success" role="alert">
                        Voto inserito correttamente
                    </div>
                <?php
            }
        }
    ?>
    <?php if (isset($esami)){ ?>
        <h2>Inserisci i voti degli esami</h2>
        <table class="table table-dark table-striped">
        <thead>
            <tr>
            <th scope="col">ID appello</th>
            <th scope="col">Nome insegnamento</th>
            <th scope="col">Data</th>
            <th scope="col">Matricola studente</th>
            <th scope="col">Nome e cognome studente</th>
            <th scope="col">Inserisci voto</th>
        </tr>
    </thead>
    <tbody>
        <?php foreach ($esami as $esame) {?>
            <tr>
                <td><?php print($esame[0]) ?></td>
                <td><?php print($esame[1]) ?></td>
                <td><?php print($esame[2]) ?></td>
                <td><?php print($esame[4]) ?></td>
                <td><?php print($esame[5]) ?></td>
                <td>
                    <form action='../lib/registravoto.php' method='POST'>
                        <input type='hidden' name="id_appello" value='<?php echo $esame[0];?>'>
                        <input type='hidden' name="id_studente" value='<?php echo $esame[3];?>'>
                        <input type="text" class="form-control" id="exampleInputEmail1" aria-describedby="emailHelp" name='voto'>
                        <button type="submit" class="btn btn-success">Inserisci voto</button>
                    </form>
                </td>
            </tr>
        <?php } ?>
    </table>
    <?php } ?>
  </body>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
</html>