<?php

    require_once 'ChatsDB.php';
    
    $sender_id = 1;//$_POST['sender_id'];
    $receiver_id = 11;//$_POST['receiver_id'];

    $chat = new ChatsDB();
    $chat->createChat($sender_id,$receiver_id);