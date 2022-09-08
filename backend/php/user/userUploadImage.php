<?php
    
    require_once 'UsersAccountDB.php';
    
    $userId = $_POST['userId'];

    $uploader = new UsersAccountDB();
    $response = $uploader->uploadImage($userId);
    
    $jsonArray = array("response"=>(bool)$response);
    echo json_encode($jsonArray);
