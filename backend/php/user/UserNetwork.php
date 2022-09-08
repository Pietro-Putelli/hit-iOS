<?php

    require_once 'UsersAccountDB.php';
    
    class UserNetwork {
        
        function __construct() { }
        
        function getUserFollowing($userId) {
            
            
            $userObj = new UsersAccountDB();
            $users = $userObj->getUsersNotFollowed($userId);    
            return $users;
            
        }
        
        private function getUserFollowing1($userId,$limit) {
            $userObj = new UsersAccountDB();
            $users = $userObj->getUserFollowingLimited($userId,0,$limit);
            $userFollowingIds = array();
            foreach ($users as $user) {
                array_push($userFollowingIds,$user->getID());
            }
            return $userFollowingIds;
        }
        
        function getUserFollowing10($userId,$limit) {
            $userIds = $this->getUserFollowing1($userId,$limit);

            $userObj = new UsersAccountDB();
            $users = array();

            foreach ($userIds as $followerId) {
                $users1 = $userObj->getUserNotFollowingBack($userId,$followerId,$limit);
                foreach ($users1 as $user) {
                    $id = $user->getID();
                    if (!$this->id_in_array($users,$id)) {
                        array_push($users,$user);
                    }
                }
            }
            return $users;
        }
        
        private function id_in_array($users,$userId) {
            foreach($users as $user) {
                if ($userId == $user->getID()) {
                    return true;
                }
            }
            return false;
        }
    }