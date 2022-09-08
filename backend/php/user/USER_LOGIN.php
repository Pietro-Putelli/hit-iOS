<?php

    require_once 'UsersAccountDB.php';
    
    $username = $_POST['username'];
    $password = $_POST['password'];
    
    $user = new UsersAccountDB();
    $userObject = $user->login($username,md5($password));

    if (!empty($userObject)) {
        $jsonArray = array(
            "user_id" => (int) $userObject->getID(),
            "user_name" => $userObject->getUsername(),
            "email" => $userObject->getUserEmail(),
            "bio" => $userObject->getUserBio(),
            "webSite" => $userObject->getUserWebSite(),
            "instagram" => $userObject->getUserInstagram()
            );
        echo json_encode($jsonArray);
    } else {
        echo json_encode(new stdClass);
    }