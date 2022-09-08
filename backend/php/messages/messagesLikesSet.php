<?php

    require_once 'MessagesDB.php';

    $message_id = $_POST['message_id'];
    $user_id = $_POST['user_id'];
    $input = $_POST['input'];
    
    $messageObj = new MessagesDB();
    
    if ($input) {
        $messageObj->addLike($message_id,$user_id);
        return;
    }
    $messageObj->removeLike($message_id,$user_id);