<?php

    require_once 'UsersAccountDB.php';

    $userId = $_POST['userId'];
    $username = $_POST['username'];

    $userObj = new UsersAccountDB();
    $user = $userObj->getUserByUsername($username,$userId);

    echo json_encode($user->toArray());
