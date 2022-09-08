<?php

  require_once 'UsersAccountDB.php';

  $userId = $_POST['userId'];
  $followingId = $_POST['followingId'];
  $follow = $_POST['follow'];

  $user = new UsersAccountDB();
  if ($follow == 1) {
    $response = $user->followUser($userId,$followingId);
  } else {
    $response = $user->unfollowUser($userId,$followingId);
  }

  $jsonArray = array("response"=>(bool)$response);
  echo json_encode($jsonArray);
