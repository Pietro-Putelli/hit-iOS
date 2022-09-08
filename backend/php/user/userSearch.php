<?php

    require_once 'UsersAccountDB.php';

    $user_id = $_POST['user_id'];
    $input = $_POST['input'];
    $offset = $_POST['offset'];

    $userDB = new UsersAccountDB();
    $users = $userDB->searchUsers($user_id,$input,$offset);

    $jsonArray = array();

    foreach ($users as $user) {
        array_push($jsonArray,$user->toArray());
    }

    echo json_encode($jsonArray);
