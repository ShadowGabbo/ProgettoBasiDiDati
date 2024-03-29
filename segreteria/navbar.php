<nav class="navbar navbar-dark bg-dark">
    <div class="container-fluid">
      <a class="navbar-brand" href="#">Segreteria</a>
      <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
      </button>
      <div class="collapse navbar-collapse" id="navbarSupportedContent">
        <ul class="navbar-nav me-auto mb-2 mb-lg-0">
          <li class="nav-item">
            <a class="nav-link" href="home.php">Home</a>
          </li>
          <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
            Studente
          </a>
          <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
            <li><a class="dropdown-item" href="inseriscistudenti.php">Inserisci studente</a></li>
            <li><a class="dropdown-item" href="visualizzastudenti.php">Visualizza studenti</a></li>
          </ul>
        </li>
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
            Docenti
          </a>
          <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
            <li><a class="dropdown-item" href="inseriscidocenti.php">Inserisci docente</a></li>
            <li><a class="dropdown-item" href="visualizzadocenti.php">Visualizza docenti</a></li>
          </ul>
        </li>
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
            Corsi di laurea
          </a>
          <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
            <li><a class="dropdown-item" href="inseriscicorsi.php">Inserisci nuovo corso di laurea</a></li>
            <li><a class="dropdown-item" href="visualizzacorsi.php">Visualizza corsi di laurea (cdl)</a></li>
          </ul>
        </li>
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
            Insegnamenti
          </a>
          <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
            <li><a class="dropdown-item" href="inserisciinsegnamenti.php">Inserisci nuovo insegnamento</a></li>
            <li><a class="dropdown-item" href="visualizzainsegnamenti.php">Visualizza insegnamenti per corso di laurea</a></li>
          </ul>
        </li>
        <li class="nav-item">
            <a class="nav-link" href="profilo.php">Profilo</a>
          </li>
        <li class="nav-item">
        <a class="nav-link" href="../logout.php">Esci</a>
        </li>
        </ul>
      </div>
    </div>
</nav>