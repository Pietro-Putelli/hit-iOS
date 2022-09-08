<?php

    require_once 'UsersAccountDB.php';
    
    $user_id = $_POST['user_id'];
    $user_data = $_POST['username'];
    
    $user = new UsersAccountDB();
    $response = $user->setUsernameBy($user_id,$user_data);
    
    $jsonArray = array("response"=>(bool)$response);
    echo json_encode($jsonArray);
    