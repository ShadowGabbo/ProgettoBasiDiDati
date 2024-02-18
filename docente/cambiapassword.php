<?php
    ini_set ("display_errors", "On");
	ini_set("error_reporting", E_ALL);
    include_once ('../lib/functions.php'); 
    include_once("navbar.php");
    session_start();

    if (!isset($_SESSION['id'])){
        redirect('../index.php');
    }
?>
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Profilo Studente</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">

  </head>
  <body>
  <div class="container-fluid">
    <?php
        if (isset($_SESSION['flag'])){
            if ($_SESSION['flag'] == false){
                ?>
                    <div class="alert alert-danger" role="alert">
                        Errore nella modifica della password, riprovare
                    </div>
                <?php
            }
        }
    ?>
    <h1>Cambia password</h1>
    <form id="myform" method="POST" action="../lib/cambiapassword.php">
    <div class="mb-3">
        <label for="exampleInputEmail1" class="form-label">Nuova password</label>
        <input type="text" class="form-control" id="exampleInputEmail1" aria-describedby="emailHelp" name="password">
    </div>
    <button type="submit" class="btn btn-primary">Conferma</button>
    </form>
  </div>
  </body>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
</html>