<?php

  require_once 'UsersAccountDB.php';

  $userId = $_POST['userId'];
  $oldPassword = md5($_POST['oldPassword']);
  $newPassword = md5($_POST['newPassword']);

  $user = new UsersAccountDB();
  $response = $user->editPassword($userId,$oldPassword,$newPassword);

  $jsonArray = array("response"=>(bool)$response);
  echo json_encode($jsonArray);
