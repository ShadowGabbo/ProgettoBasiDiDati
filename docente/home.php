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
    <title>Home Docente</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
    <link rel="stylesheet" href="../css/esami.css">
  </head>
  <body>
    <div class="container-fluid">
      <?php include_once("navbar.php"); ?>
      <h3>Benvenuto/a docente "<?php echo $nome_completo?>" (<?php echo $email?>)</h3>
      <p>Naviga con la navbar oppure seleziona il tuo argomento di interesse</p>
      
      <br>
      <div class="row">
        <div class="col-12">
            <div class="card-body">
                <a href="visualizzainsegnamenti.php"><h2 class="card-text">Visualizza insegnamenti</h2></a>
                <p>Gli insegnamenti di cui il docente e' responsabile</p>
            </div>
        </div>
      </div>
      <div class="row">
          <div class="col-12">
              <div class="card-body">
                  <a href="inserisciappelli.php"><h2 class="card-text">Crea appello</h2></a>
                  <p>Crea un appello per un tuo insegnamento di cui sei responsabile</p>
              </div>
          </div>
      </div>
      <div class="row">
          <div class="col-12">
              <div class="card-body">
                  <a href="calendarioesami.php"><h2 class="card-text">Visualizza appelli</h2></a>
                  <p>Visualizza gli appelli di cui sei responsabile</p>
              </div>
          </div>
      </div>
      <div class="row">
          <div class="col-12">
              <div class="card-body">
                  <a href="registraesiti.php"><h2 class="card-text">Registra voto/esito</h2></a>
                  <p>Registra un voto di un esame di uno studente iscritto</p>
              </div>
          </div>
      </div>
    </div>
  </body>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
</html>