<?php

    require_once 'MessagesDB.php';

    $chat_id = $_POST['chat_id'];
    $user_id = $_POST['user_id'];
    
    $messageObj = new MessagesDB();
    $messageObj->deleteReadMessages($chat_id,$user_id);