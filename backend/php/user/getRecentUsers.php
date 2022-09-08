<?php

  require_once 'UsersAccountDB.php';

  $myUserId = $_POST['myUserId'];
  $userIds = explode(',', $_POST['userIds']);

  $userObj = new UsersAccountDB();
  $users = $userObj->getRecentUsers($myUserId,$userIds);

  $jsonArray = array();
  foreach ($users as $user) {
      array_push($jsonArray,$user->toArray());
  }

  echo json_encode($jsonArray);
 ?>
