<?php

    require_once 'UsersAccountDB.php';
    
    $user_id = $_POST['user_id'];
    $instagram = $_POST['user_instagram'];
    
    $user = new UsersAccountDB();
    $response = $user->setupUserInstagram($user_id,$instagram);
    
    $jsonArray = array("response"=>(bool)$response);
    echo json_encode($jsonArray);