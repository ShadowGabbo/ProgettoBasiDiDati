<?php
    ini_set ("display_errors", "On");
	ini_set("error_reporting", E_ALL);
    include_once ('../lib/functions.php'); 
    session_start();

    if (!isset($_SESSION['id'])){
        redirect('../index.php');
    }

    $arr = get_credenziali($_SESSION['id']);
    $nome = $arr['nome'];
    $cognome = $arr['cognome'];
    $email = $arr['email'];
    $password = $arr['password'];
?>
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Profilo segreteria</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">

  </head>
  <body>
  <div class="container-fluid">
    <?php include_once("navbar.php"); ?>
    <h1></h1>
    <div class="card" style="width: 18rem;">
    <div class="card-body">
        <h3 class="card-title">Profilo segreteria</h5>
        <h5>Id: <?php print($_SESSION['id']) ?></h5>
        <h5>Nome: <?php print($nome)?></h5>
        <h5>Cognome: <?php print($cognome)?></h5>
        <h5>Email: <?php print($email)?></h5>
        <h5>password: <?php print($password)?></h5>
        <a href="cambiapassword.php" class="btn btn-primary">Cambia password</a>
    </div>
    </div>
  </div>
    

  </body>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
</html>