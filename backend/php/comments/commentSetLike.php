<?php

  require_once 'CommentsDB.php';

  $userId = $_POST['userId'];
  $commentId = $_POST['commentId'];
  $liked = $_POST['liked'];

  $commentDb = new CommentsDB();

  if ($liked == 1) {
    $response = $commentDb->setLikeBy($userId,$commentId);
  } else {
    $response = $commentDb->setUnLikeBy($userId,$commentId);
  }

  $jsonArray = array("response"=>(bool)$response);
  echo json_encode($jsonArray);

 ?>
