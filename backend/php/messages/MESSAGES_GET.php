<?php

    require_once 'MessagesDB.php';

    $chat_id = $_POST['chat_id'];

    $messageObj = new MessagesDB();
    $messages = $messageObj->getAllMessagesBy($chat_id);

    $jsonsArray = array();
    foreach($messages as $message) {
        array_push($jsonsArray, $message->toJson());
    }
    
    echo json_encode($jsonsArray);