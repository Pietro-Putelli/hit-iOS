<?php

    require_once 'ChatsDB.php';
    
    $chat_id = $_POST['chat_id'];
    
    $chatObj = new ChatsDB();
    $response = $chatObj->uploadImage($chat_id);
    
    $jsonResponse = array("response"=>(int)$response);
    echo json_encode($jsonResponse);