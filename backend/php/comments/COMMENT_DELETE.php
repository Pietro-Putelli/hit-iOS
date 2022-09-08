<?php

    require_once 'CommentsDB.php';
    
    $comment_id = $_POST['comment_id'];
    
    $comment = new CommentsDB();
    $response = $comment->deleteCommentByID($comment_id);
    
    $jsonArray = array("response"=>(bool)$response);
    echo json_encode($jsonArray);