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
  $nome_completo = $nome.' '.$cognome;
?>
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Home segreteria</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">

  </head>
  <body>
    <div class="container-fluid">
      <?php include_once("navbar.php"); ?>
      <br>
      <h3>Benvenuto/a segretario/a "<?php echo $nome_completo?>" (<?php echo $email?>)</h3>
      <p>Naviga con la navbar per cercare il tuo argomento di interesse</p>
    </div>
  </body>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
</html>