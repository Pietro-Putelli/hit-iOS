<?php

    require_once 'MessagesDB.php';
    
    $data = json_decode(file_get_contents('php://input'), true);

    $message = new MessagesDB();
    $id = $message->setMessage($data["sender_id"],$data["receiver_id"],$data["content"],$data["reply_id"],$data["chat_id"],$data["mDate"]);
    
    $chatObj = new ChatsDB();
    $response = $chatObj->uploadImage($chat_id);
    
    $jsonArray = array(
        "id"=>(int)$id,
        "response" => (int)$response
    );
    echo json_encode($jsonArray);