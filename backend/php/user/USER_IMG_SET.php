<?php
    
    require_once 'UsersAccountDB.php';
    
    $email = $_POST['email'];

    $uploader = new UsersAccountDB();
    $response = $uploader->uploadImage($email);
    
    $jsonArray = array("response"=>(bool)$response);
    echo json_encode($jsonArray);

