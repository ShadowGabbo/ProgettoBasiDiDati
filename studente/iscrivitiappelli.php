<?php
    ini_set ("display_errors", "On");
	ini_set("error_reporting", E_ALL);
    include_once ('../lib/functions.php'); 
    session_start();

    if (!isset($_SESSION['id'])){
        redirect('../index.php');
    }

    $appelli = get_appelli_studente($_SESSION['id']);
?>
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Visualizza appelli</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">

  </head>
  <body>
  <div class="container-fluid">
    <?php include_once("navbar.php"); ?>
    <?php
        if (isset($_SESSION['iscriviti'])){
            if ($_SESSION['iscriviti'] == false){
                ?>
                    <div class="alert alert-danger" role="alert">
                        Errore nell'iscrizione
                    </div>
                <?php
            }else{
                ?>
                    <div class="alert alert-success" role="alert">
                        Iscrizione all'esame avvenuta con successo
                    </div>
                <?php
            }
        }
    ?>

    <?php if (isset($appelli)){ ?>
        <h3>Gli appelli disponibili soddisfano i seguenti requisiti:</h3>
        <ul>
            <li>appelli di insegnamenti del proprio corso di studi</li>
            <li>appelli non passati ma nel "futuro"</li>
            <li>sono presenti anche appelli che non soddisfano le propedeuticita'</li>
        </ul>
        <br>
        <?php if (isset($appelli)){ ?>
        <h3>Iscriviti ad un appello</h3>
        <table class="table table-dark table-striped">
        <thead>
            <tr>
            <th scope="col">Id</th>
            <th scope="col">Nome insegnamento</th>
            <th scope="col">Nome Corso</th>
            <th scope="col">Nome Docente</th>
            <th scope="col">Data</th>
            <th scope="col">Orario</th>
            <th scope="col">Luogo</th>
            <th scope="col">Iscriviti</th>
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
                <td><?php print($appello[6]) ?></td>
                <?php if (check_iscrizione($appello[0], $_SESSION['id'])){ ?>
                    <td><button type="submit" class="btn btn-success disabled">Gia iscritto</button></td>
                <?php }else{?>
                    <form action='../lib/iscrivitiappello.php' method='get'>
                        <input type='hidden' name="id" value='<?php echo $appello[0]; ?>'>
                        <td><button type="submit" class="btn btn-success">Iscriviti</button></td>
                    </form>
                <?php }?>
            </tr>
        <?php } ?>
    </table>
    <?php } ?>
    <?php } ?>
  </body>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
</html>