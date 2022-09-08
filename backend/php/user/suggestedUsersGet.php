<?php

    require_once 'UsersAccountDB.php';
    require_once 'UserNetwork.php';

    $userId = $_POST['user_id'];
    $offset = $_POST['offset'];

    $usersAccount = new UsersAccountDB();
    $users = $usersAccount->getSuggestedUsers($userId,$offset);

    $jsonArray = array();
    foreach($users as $user) {
        array_push($jsonArray,$user->toArray());
    }

    echo json_encode($jsonArray);
