<?php

    require_once 'CommentsDB.php';
    
    $comment_id = $_POST['comment_id'];
    $author_id = $_POST['author_id'];
    $content = $_POST['content'];
    $tagged_users = $_POST['tagged_users'];
    $options = $_POST['options'];
    $date = $_POST['date'];
    
    $comment = new CommentsDB();
    $response = $comment->createReply($comment_id,$author_id,$content,$tagged_users,$options,$date);
    
    $jsonArray = array("response"=>(bool)$response);
    echo json_encode($jsonArray);