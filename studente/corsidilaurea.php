<?php
    ini_set ("display_errors", "On");
	ini_set("error_reporting", E_ALL);
    include_once ('../lib/functions.php'); 
    session_start();

    if (!isset($_SESSION['id'])){
        redirect('../index.php');
    }

    $courses = get_courses();

    if (isset($_POST)){
        if (!empty($_POST['id_corso'])){
            // trovo tutti gli insegnamenti del corso 'id_corso'
            $insegnamenti = get_all_insegnamenti($_POST['id_corso']);
            $nome_corso = get_name_course($_POST['id_corso']);
        }
    }
    
?>
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Visualizza insegnamenti e corsi di laurea</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">

  </head>
  <body>
  <div class="container-fluid">
    <?php include_once("navbar.php"); ?>
    <h2>Seleziona un corso di studio (cdl) per visualizzare i suoi insegnamenti</h2>
    <form method="POST" action="<?php print($_SERVER['PHP_SELF'])?>">
    <div class="mb-3">
        <label for="exampleInputPassword1" class="form-label">Seleziona corso</label>
        <select class="form-select" aria-label="Default select example" name="id_corso">
            <?php foreach ($courses as $course) { ?>
                <option value="<?php echo $course[0]?>"><?php echo $course[1]?></option>
            <?php } ?>
        </select>
    </div>
    <button type="submit" class="btn btn-primary">Visualizza gli insegnamenti</button>
    </form>
    <br>
    <?php if (isset($insegnamenti)){ ?>
        <h3>Insegnamenti del corso <?php echo $nome_corso ?>:</h3>
        <table class="table table-dark table-striped">
        <thead>
            <tr>
            <th scope="col">ID</th>
            <th scope="col">Nome</th>
            <th scope="col">Descrizione</th>
            <th scope="col">Anno erogazione</th>
            <th scope="col">CFU</th>
            <th scope="col">Nome docente</th>
            <th scope="col">Insegnamenti propedeutici</th>
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
                <td><?php 
                    $propedeutici = get_all_propedeutici($insegnamento[0]);
                    if (empty($propedeutici)) { ?>
                        Nessun insegnamento propedeutico
                    <?php }else{
                        foreach ($propedeutici as $propedeutico){
                            echo $propedeutico.'<br>';
                        }
                    } ?>
            </tr>
        <?php } ?>
    </table>
    <?php } ?>
  </body>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
</html>