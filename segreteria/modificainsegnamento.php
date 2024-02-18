<?php
    ini_set ("display_errors", "On");
	ini_set("error_reporting", E_ALL);
	include_once ('../lib/functions.php'); 
    session_start();

    if (isset($_POST)){
        if (!empty($_POST['id_insegnamento'])) {
            $insegnamento_id = $_POST['id_insegnamento'];
            $arr = get_insegnamento($insegnamento_id);
        }
    }
?>
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Modifica insegnamento</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">

  </head>
  <body>
  <div class="container-fluid">
    <?php include_once("navbar.php"); ?>
    <br>
    <h3>Modifica insegnamento: <?php echo $arr[0]?></h3>
    <form method="POST" action="../lib/modificainsegnamento.php">
    <input value="<?php echo $arr[0]?>" type="hidden" class="form-control" id="exampleInputPassword1" name="id">
    <div class="mb-3">
        <label for="exampleInputPassword1" class="form-label">Nome insegnamento</label>
        <input value="<?php echo $arr[1]?>" type="text" class="form-control" id="exampleInputPassword1" name="nome">
    </div>
    <div class="mb-3">
        <label for="exampleInputEmail1" class="form-label">Descrizione insegnamento</label>
        <input value="<?php echo $arr[2]?>" type="text" class="form-control" id="exampleInputEmail1" aria-describedby="emailHelp" name="descrizione">
    </div>
    <div class="mb-3">
        <label for="exampleInputEmail1" class="form-label">Anno insegnamento</label>
        <input value="<?php echo $arr[3]?>" type="text" class="form-control" id="exampleInputEmail1" aria-describedby="emailHelp" name="anno">
    </div>
    <div class="mb-3">
        <label for="exampleInputEmail1" class="form-label">Cfu insegnamento</label>
        <input value="<?php echo $arr[4]?>" type="text" class="form-control" id="exampleInputEmail1" aria-describedby="emailHelp" name="cfu">
    </div>
    <div class="mb-3">
        <label for="exampleInputEmail1" class="form-label">Corso di laurea insegnamento</label>
        <input value="<?php echo $arr[5]?>" type="text" class="form-control" id="exampleInputEmail1" aria-describedby="emailHelp" name="corso">
    </div>
    <div class="mb-3">
        <label for="exampleInputEmail1" class="form-label">Docente</label>
        <input value="<?php echo $arr[6]?>" type="text" class="form-control" id="exampleInputEmail1" aria-describedby="emailHelp" name="docente">
    </div>
    <fieldset disabled>
        <div class="mb-3">
            <label for="exampleInputEmail1" class="form-label">Insegnamenti propedeutici</label>
            <input value="<?php echo $arr[7]?>" type="text" class="form-control" id="exampleInputEmail1" aria-describedby="emailHelp" name="propedeutici">
        </div>
    </fieldset>
    <button type="submit" class="btn btn-primary">Modifica insegnamento</button>
    </form>
    </body>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
</html>