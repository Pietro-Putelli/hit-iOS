<?php

    require_once 'UsersAccountDB.php';
    
    $user_id = $_POST['user_id'];
    $username = $_POST['username'];
    
    $user = new UsersAccountDB();
    $response = $user->checkUniqueFor($user_id,$username);
    
    $jsonArray = array("response"=>(bool)$response);
    echo json_encode($jsonArray);
    
