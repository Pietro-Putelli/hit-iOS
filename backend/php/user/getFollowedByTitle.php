<?php

    require_once 'UsersAccountDB.php';

    $myUserId = $_POST['myUserId'];
    $userId = $_POST['userId'];
    $limit = 2;

    $userObj = new UsersAccountDB();
    $usernames = $userObj->getFollowedByTitle($myUserId,$userId,$limit,0);

    echo json_encode($usernames);
