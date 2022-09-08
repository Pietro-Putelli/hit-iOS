<?php

    require_once 'UsersAccountDB.php';

    $mainUserId = $_POST['mainUserId']; // spiegato in followers il funzionamento, perche sicuro te ne dimentichi.
    $userId = $_POST['userId'];
    $offset = $_POST['offset'];

    $userObj = new UsersAccountDB();
    $users = $userObj->getUserFollowing($userId,$mainUserId,$offset);

    $jsonArray = array();
    foreach ($users as $user) {
        array_push($jsonArray,$user->toArray());
    }

    echo json_encode($jsonArray);
