<?php

    require_once 'MessagesDB.php';
    
    $message_id = $_POST['message_id'];
    
    $comment = new MessagesDB();
    $response = $comment->deleteMessageBy($message_id);
    
    $jsonArray = array("response"=>(bool)$response);
    echo json_encode($jsonArray);