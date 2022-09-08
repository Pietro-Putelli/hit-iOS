<?php

    require_once 'UsersAccountDB.php';

    $myUserId = $_POST['myUserId'];
    $userId = $_POST['userId'];

    $userObj = new UsersAccountDB();
    $user = $userObj->getUserById($myUserId,$userId);

    echo json_encode($user->toArray());
