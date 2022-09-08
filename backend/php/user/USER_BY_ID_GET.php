<?php

    require_once 'UsersAccountDB.php';
    
    $my_user_id = $_POST['my_user_id'];
    $user_id = $_POST['user_id'];
    
    $userObj = new UsersAccountDB();
    $user = $userObj->getUserBy($my_user_id,$user_id);
    
    $jsonArray = array(
        "id" => (int) $user->getID(),
        "username" => $user->getUsername(),
        "email" => $user->getUserEmail(),
        "bio" => $user->getUserBio(),
        "webSite" => $user->getUserWebSite(),
        "instagram" => $user->getUserInstagram(),
        "followBack" => (bool)$user->getFollowBack()
    );
    
    echo json_encode($jsonArray);