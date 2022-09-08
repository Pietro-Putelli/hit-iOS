<?php

    require_once 'MessagesDB.php';
    $data = json_decode(file_get_contents('php://input'), true);

    $message = new MessagesDB();
    $id = $message->setMessage($data["sender_id"],$data["receiver_id"],$data["content"],$data["reply_id"],$data["chat_id"],$data["mDate"]);
    
    $jsonArray = array("id"=>(int)$id);
    echo json_encode($jsonArray);