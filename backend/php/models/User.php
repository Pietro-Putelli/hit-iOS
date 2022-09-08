<?php

    class User {
        
        protected $id;
        protected $username;
        protected $name;
        protected $email;
        protected $bio;
        protected $link1;
        protected $instagram;
        protected $followBack;
        
        function __construct($id,$username,$name,$email,$bio,$link1,$instagram,$followBack) {
            $this->id = $id;
            $this->username = $username;
            $this->name = $name;
            $this->email = $email;
            $this->bio = $bio;
            $this->link1 = $link1;
            $this->instagram = $instagram;
            $this->followBack = $followBack;
        }
        
        function getUsername() {
            return $this->username;
        }

        function toArray() {
            return array(
                "id" => (int)$this->id,
                "username" => $this->username,
                "name" => $this->name,
                "bio" => $this->bio,
                "link" => $this->link1,
                "instagram" => $this->instagram,
                "followBack" => (bool)$this->followBack
            );
        }
    }
