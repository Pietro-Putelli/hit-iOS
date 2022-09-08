<?php

    require_once 'CommentsDB.php';

    $data = json_decode(file_get_contents('php://input'), true);

    $user = new UsersAccountDB();
    $userIds = $user->getTaggedUserIdsBy($data["taggedUsers"]);

    $comment = new CommentsDB();
    $commentId = $comment->createComment($data["authorId"],$data["content"],$data["anonymous"],$data["date"]);
    $comment->addUserTagToComment($userIds,$commentId);

    $response = false;
    if ($commentId != NULL) {
        $response = true;
    }

    $jsonArray = array("response"=>(bool)$response);
    echo json_encode($jsonArray);
