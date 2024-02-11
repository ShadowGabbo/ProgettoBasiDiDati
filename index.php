<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
    <link rel="stylesheet" href="css/utils.css">
    <title>Login myUni</title>
</head>
<body>
    <div class="container">
        <img src="images/logo.png" alt="logo" class="center">
        <br>
        
        <div id="form_container">
            <form id="myform" method="POST" action="lib/login.php">
                <h3>Login</h3>
                <div class="mb-3">
                    <label for="exampleInputEmail1" class="form-label">Email utente</label>
                    <input type="email" class="form-control" id="exampleInputEmail1" aria-describedby="emailHelp" name='usr'>
                </div>
                <div class="mb-3">
                    <label for="exampleInputPassword1" class="form-label">Password</label>
                    <input type="password" class="form-control" id="exampleInputPassword1" name="psw">
                </div>
                <div class="mb-3">
                    <select class="form-select" aria-label="Default select example" name="tipo">
                        <option selected value="studente">Studente (@studente.it)</option>
                        <option value="docente">Docente (@docente.it)</option>
                        <option value="segreteria">Segreteria (@segreteria.it)</option>
                    </select>
                    <br>
                </div>
                <button type="submit" class="btn btn-primary">Entra</button>
            </form>
        </div>
    </div>
</body>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js" integrity="sha384-I7E8VVD/ismYTF4hNIPjVp/Zjvgyol6VFvRkX/vR+Vc4jQkC+hVqc2pM8ODewa9r" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.min.js" integrity="sha384-BBtl+eGJRgqQAUMxJ7pMwbEyER4l1g+O15P+16Ep7Q9Q+zqX6gSbd85u4mG4QzX+" crossorigin="anonymous"></script>
</html>