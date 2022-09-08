<?php

    require_once 'UsersAccountDB.php';
    
    $user_id = $_POST['user_id'];
    $follower_id = $_POST['follower_id'];
    
    $user = new UsersAccountDB();
    $user->addFollower($user_id,$follower_id);