<?php

    require_once 'ChatsDB.php';
    
    $userId = $_POST['userId'];
    $input = $_POST['input'];
    
    $chatObj = new ChatsDB;
    $chats = $chatObj->searchMyChats($input,$userId);
    
    $jsonsArray = array();
    foreach($chats as $chat) {
        $jsonArray = $chat->toArray();
        array_push($jsonsArray,$jsonArray);
    }
    
    echo json_encode($jsonsArray);