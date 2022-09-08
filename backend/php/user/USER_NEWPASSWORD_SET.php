<?php

    require_once 'UsersAccountDB.php';
    
    $user_id = $_POST['user_id'];
    $current_password = $_POST['currentPassword'];
    $new_password = $_POST['newPassword'];
    
    $user = new UsersAccountDB();
    $response = $user->checkUserCurrentPassword($user_id,md5($current_password),md5($new_password));
    
    $jsonArray = array("response"=>$response);
    echo json_encode($jsonArray);