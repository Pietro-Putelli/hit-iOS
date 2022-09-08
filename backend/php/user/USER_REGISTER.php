<?php

    require_once 'UsersAccountDB.php';
    
    $username = $_POST['username'];
    $email = $_POST['email'];
    $password = $_POST['password'];
    
    if (!file_exists("../users_data/$email")) {
        mkdir("../users_data/$email", 0755, true);
    }
    
    $user = new UsersAccountDB();
    $user->register($username,$email,md5($password));