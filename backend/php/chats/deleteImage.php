<?php

    require_once 'ChatsDB.php';
    
    $chat_id = $_POST['chat_id'];
    $message_id = $_POST['message_id'];
    
    $chatObj = new ChatsDB();
    $chatObj->deleteImageForChat($chat_id,$message_id);