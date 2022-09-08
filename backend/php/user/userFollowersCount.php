<?php
    
    require_once 'UsersAccountDB.php';
    
    $user_id = $_POST['user_id'];
    
    $user = new UsersAccountDB();
    $counts = $response = $user->getFollowerCount($user_id);
    
    $jsonArray = array(
        "followers" =>(int)$counts[0],
        "following" =>(int)$counts[1]
    );
    
    echo json_encode($jsonArray);