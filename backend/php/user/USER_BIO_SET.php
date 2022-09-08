<?php

    require_once 'UsersAccountDB.php';
    
    $user_id = $_POST['user_id'];
    $user_bio = $_POST['user_bio'];
    
    $user = new UsersAccountDB();
    $response = $user->setUserBioBy($user_id,$user_bio);
    
    $jsonArray = array("response"=>$response);
    echo json_encode($jsonArray);