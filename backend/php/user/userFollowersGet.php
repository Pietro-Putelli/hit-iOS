<?php

    require_once 'UsersAccountDB.php';

    $mainUserId = $_POST['mainUserId']; // l'id dell'utente che visita la view following / followers di un qualsiasi utente, per permettere di mostrare all'iutente che visita se segue o meno i profili seguiti dal profilo che sta visitando.
    $userId =  $_POST['userId'];
    $offset = $_POST['offset'];

    $userObj = new UsersAccountDB();
    $users = $userObj->getUserFollowers($userId,$mainUserId,$offset);

    $jsonArray = array();
    foreach ($users as $user) {
        array_push($jsonArray,$user->toArray());
    }

    echo json_encode($jsonArray);
