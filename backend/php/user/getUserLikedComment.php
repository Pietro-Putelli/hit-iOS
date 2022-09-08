
<?php

  require_once 'UsersAccountDB.php';

  $userId = $_POST['userId'];
  $commentId = $_POST['commentId'];
  $offset = $_POST['offset'];

  $userDb = new UsersAccountDB();
  $users = $userDb->getUsersLikedComment($userId,$commentId,$offset);

  $jsonArray = array();
  foreach ($users as $user) {
      array_push($jsonArray,$user->toArray());
  }

  echo json_encode($jsonArray);
