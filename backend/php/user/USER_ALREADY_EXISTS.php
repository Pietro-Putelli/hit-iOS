<?php

    require_once 'UsersAccountDB.php';
    
    $email = $_POST['email'];
    $username = $_POST['username'];
    
    $user = new UsersAccountDB();
    
    $email_response = $user->emailAlreadyExists($email);
    $username_response = $user->usernameAlreadyExists($username);
    
    $jsonArray = array(
        "1"=> (bool) $email_response,
        "2"=> (bool) $username_response
        );
        
    echo json_encode($jsonArray);