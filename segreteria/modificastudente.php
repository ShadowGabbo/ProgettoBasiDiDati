<?php
    ini_set ("display_errors", "On");
	ini_set("error_reporting", E_ALL);
	include_once ('../lib/functions.php'); 
    session_start();

    if (isset($_POST)){
        if (!empty($_POST['id_studente'])) {
            $studente_id = $_POST['id_studente'];
            $arr = get_student($studente_id);
        }
    }
?>
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Modifica studente</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">

  </head>
  <body>
  <div class="container-fluid">
    <?php include_once("navbar.php"); ?>
    <br>
    <h3>Modifica studente: <?php echo $arr[0]?></h3>
    <form method="POST" action="../lib/modificastudente.php">
    <input value="<?php echo $arr[0]?>" type="hidden" class="form-control" id="exampleInputPassword1" name="id">
    <div class="mb-3">
        <label for="exampleInputPassword1" class="form-label">Nome studente</label>
        <input value="<?php echo $arr[1]?>" type="text" class="form-control" id="exampleInputPassword1" name="nome">
    </div>
    <div class="mb-3">
        <label for="exampleInputEmail1" class="form-label">Cognome studente</label>
        <input value="<?php echo $arr[2]?>" type="text" class="form-control" id="exampleInputEmail1" aria-describedby="emailHelp" name="cognome">
    </div>
    <div class="mb-3">
        <label for="exampleInputEmail1" class="form-label">Email studente</label>
        <input value="<?php echo $arr[3]?>" type="text" class="form-control" id="exampleInputEmail1" aria-describedby="emailHelp" name="email">
    </div>
    <div class="mb-3">
        <label for="exampleInputEmail1" class="form-label">Matricola studente</label>
        <input value="<?php echo $arr[4]?>" type="text" class="form-control" id="exampleInputEmail1" aria-describedby="emailHelp" name="matricola">
    </div>
    <div class="mb-3">
        <label for="exampleInputEmail1" class="form-label">Codice corso di laurea</label>
        <input value="<?php echo $arr[5]?>" placeholder="codice di massimo 6 cifre/lettere" type="text" class="form-control" id="exampleInputEmail1" aria-describedby="emailHelp" name="cdl">
    </div>
        <button type="submit" class="btn btn-primary">Modifica studente</button>
    </form>
    </body>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
</html>