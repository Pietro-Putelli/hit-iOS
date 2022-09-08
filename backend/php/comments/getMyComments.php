<?php

    require_once 'CommentsDB.php';

    $myUserId = $_POST['myUserId'];
    $userId = $_POST['userId'];
    $offset = $_POST['offset'];

    $commentDb = new CommentsDB();

    $comments = $commentDb->getMyCommentsBy($myUserId,$userId,$offset);
    $jsonArray = array();

    foreach ($comments as $comment) {
      array_push($jsonArray,$comment->toArray());
    }

    echo json_encode($jsonArray);
