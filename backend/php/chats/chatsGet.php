<?php

    require_once 'ChatsDB.php';

    $user_id = $_POST['userId'];

    $chatObj = new ChatsDB();
    $chats = $chatObj->getChatsBy($user_id);

    $jsonsArray = array();
    foreach($chats as $chat) {
        $jsonArray = $chat->toArray();
        array_push($jsonsArray,$jsonArray);
    }

    echo json_encode($jsonsArray);
