<?php

    require_once 'UsersAccountDB.php';
    
    $userDb = new UsersAccountDB();
    $user = $userDb->selectAllUsers();
    
    $jsonArray = array(
        "id" => (int) $user->getID(),
        "username" => $user->getUsername(),
        "email" => $user->getUserEmail(),
        "bio" => $user->getUserBio(),
        "webSite" => $user->getUserWebSite(),
        "instagram" => $user->getUserInstagram()
    );
    
    echo json_encode($jsonArray);