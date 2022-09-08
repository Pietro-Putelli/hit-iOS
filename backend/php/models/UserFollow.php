<?php
    
    require_once 'User.php';
    
    class UserFollow extends User {
        
        public $followBack;
        
        function __construct($user_id,$user_name,$email,$password,$bio,$webSite,$instagram,$followBack) {
            parent::__construct($user_id,$user_name,$email,$password,$bio,$webSite,$instagram);
            $this->followBack = $followBack;
        }
        
        function getFollowBack() {
            return $this->followBack;
        }
    }