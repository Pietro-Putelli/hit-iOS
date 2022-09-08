<?php

    require_once 'ChatsDB.php';
    
    $chat_id = $_POST['chat_id'];
    
    if ($chat_id != NULL) {
        $chat = new ChatsDB();
        $chat->delete($chat_id);
    }