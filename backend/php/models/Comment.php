<?php

    class Comment {

        protected $id;
        protected $userId;
        protected $username;
        protected $content;
        protected $date;
        protected $liked;
        protected $favourited;
        protected $likedUsernames;
        protected $likedByCount;

        function __construct($id,$userId,$username,$content,$date,$liked,$favourited,$likedUsernames,$likedByCount) {
            $this->id = $id;
            $this->userId = $userId;
            $this->username = $username;
            $this->content = $content;
            $this->date = $date;
            $this->liked = $liked;
            $this->favourite = $favourited;
            $this->likedUsernames = $likedUsernames;
            $this->likedByCount = $likedByCount;
        }

        function getId() {
          return $this->id;
        }

        function toArray() {
          return array(
            "id" => (int)$this->id,
            "userId" => (int)$this->userId,
            "username" => $this->username,
            "content" => $this->content,
            "date" => $this->date,
            "liked" => (bool)$this->liked,
            "favourited" => (bool)$this->favourite,
            "likedUsernames" => $this->likedUsernames,
            "likedByCount" => $this->likedByCount
          );
        }
    }
