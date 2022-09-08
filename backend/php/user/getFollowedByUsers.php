<?php

    require_once 'UsersAccountDB.php';

    $myUserId = $_POST['myUserId'];
    $userId = $_POST['userId'];
    $limit = 8;
    $offset = $_POST['offset'];

    $userObj = new UsersAccountDB();
    $users = $userObj->getFollowedBy($myUserId,$userId,$limit,$offset);

    $jsonArray = array();
    foreach ($users as $user) {
        array_push($jsonArray,$user->toArray());
    }

    echo json_encode($jsonArray);
