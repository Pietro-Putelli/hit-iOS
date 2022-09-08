<?php

    require_once 'UsersAccountDB.php';
    
    $user_id = $_POST['user_id'];
    $input = $_POST['input'];
    
    $user = new UsersAccountDB();
    $users = $user->searchFollowing($user_id,$input);
    
    $jsonDict = array();
    
    foreach ($users as $user) {
        $jsonArray = array(
            "id" => (int) $user->getID(),
            "username" => $user->getUsername(),
            "email" => $user->getUserEmail(),
            "bio" => $user->getUserBio(),
            "webSite" => $user->getUserWebSite(),
            "instagram" => $user->getUserInstagram(),
            "followBack" => (bool)$user->getFollowBack(),
            );
        array_push($jsonDict,$jsonArray);
    }
    
    echo json_encode($jsonDict);