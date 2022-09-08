<?php

    require_once 'UsersAccountDB.php';
    
    $user_id = $_POST['user_id'];
    $follower_id = $_POST['follower_id'];
    
    $user = new UsersAccountDB();
    $response = $user->followAlreadyExists($user_id,$follower_id);
    
    $jsonArray = array("response"=>(bool)$response);
    echo json_encode($jsonArray);