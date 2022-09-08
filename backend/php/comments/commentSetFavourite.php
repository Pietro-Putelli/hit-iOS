<?php

  require_once 'CommentsDB.php';

  $userId = $_POST['userId'];
  $commentId = $_POST['commentId'];
  $favourited = $_POST['favorited'];

  $commentDb = new CommentsDB();

  if ($favourited == 0) {
    $response = $commentDb->setUnFavourite($userId,$commentId);
  } else {
    $response = $commentDb->setFavourite($userId,$commentId);
  }

  echo json_encode(
    array("response"=>$commentId)
  );

 ?>
