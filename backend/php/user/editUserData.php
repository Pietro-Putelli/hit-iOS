<?php

    require_once 'UsersAccountDB.php';
    
    $data = json_decode(file_get_contents('php://input'), true);
    
    $user = new UsersAccountDB();
    $response = $user->editUserData($data["id"],$data["username"],$data["name"],$data["bio"],$data["instagram"],$data["link"]);
    
    $jsonArray = array("response"=>$response);
    echo json_encode($jsonArray);