<?php
// redirect function
function Redirect($url, $permanent = false) {
    header("Location: $url", true, $permanent ? 301 : 302);
    exit();
}

function check_login($usr, $psw, $tipo){
    return true;
}