<?php
    include_once ('lib/functions.php'); 
    session_start();
    // elimino tutte le variabili di sessione salvate
    unset($_SESSION);
    redirect('index.php');
?>