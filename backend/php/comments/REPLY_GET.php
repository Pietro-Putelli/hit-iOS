<?php

    require_once 'CommentsDB.php';
    
    $comment_id = $_POST['comment_id'];
    
    $commentDb = new CommentsDB();
    $comments = $commentDb->getReplies($comment_id);

    $jsonArray = array();
    
    foreach ($comments as $comment) {
        $array = array(
            "id" => (int)$comment->getID(),
            "user_name" => $comment->getUsername(),
            "date" => $comment->getDate(),
            "content" => $comment->getContent(),
            "tagged_users" => $comment->getTaggedUsers()
            );
        array_push($jsonArray,$array);
    }
    
    echo json_encode($jsonArray);