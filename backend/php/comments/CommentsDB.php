<?php

    require_once '../models/Comment.php';
    require_once '../user/UsersAccountDB.php';

     class CommentsDB {

        protected $conn;
        protected $limit = 8;

        function __construct() {
            $servername = "localhost";
            $username = "xs3xws6r_finix";
            $password = "0AFfi1iWrSlkGtIrZ";
            $databaseName = "xs3xws6r_inside";

            try {

                $this->conn = new PDO("mysql:host=$servername;dbname=$databaseName", $username, $password);
                $this->conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

            } catch(PDOException $e) {echo "Connection failed: " . $e->getMessage();}
        }

        function __destruct() {
            $this->conn = NULL;
        }


        function createComment($author_id,$content,$anonymous,$date) {
            $query = "INSERT INTO inside_comments (author_id, content, anonymous, mDate) VALUES ('$author_id','$content','$anonymous','$date')";
            $sth = $this->conn->prepare($query);

            if ($sth->execute()) {
                return $this->conn->lastInsertId();
            } else {
                return -1;
            }
        }

        function getFollowingComments($userId,$offset) {
          $query = "SELECT User.id,Comment.*,AuthorUser.username,Liked.user_id AS liked_user_id,Favourite.user_id AS favourite_user_id FROM inside_followers AS Follower
                    JOIN inside_users AS User ON (Follower.following_id = User.id)
                    JOIN inside_usertag AS UserTag ON (UserTag.user_id = Follower.following_id)
                    JOIN inside_comments AS Comment ON (Comment.id = UserTag.comment_id)
                    JOIN inside_users AS AuthorUser ON (Comment.author_id = AuthorUser.id)
                    LEFT JOIN inside_userlikes AS Liked ON (Comment.id = Liked.comment_id AND Liked.user_id = $userId)
                    LEFT JOIN inside_userfavourites AS Favourite ON (Comment.id = Favourite.comment_id)
                    WHERE Follower.user_id = $userId ORDER BY mDate DESC LIMIT $this->limit OFFSET $offset";

          $sth = $this->conn->prepare($query);

          if ($sth->execute()) {
            $comments = array();
            while($row = $sth->fetch(PDO::FETCH_ASSOC)) {
              $liked = true;
              $favourited = true;

              if ($row["liked_user_id"] == NULL) {
                $liked = false;
              }
              if ($row["favourite_user_id"] == NULL) {
                $favourited = false;
              }
              $likedByTitles = $this->getCommentLikedByTitle($userId,$row["id"]);
              $comment = new Comment($row["id"],$row["author_id"],$row["username"],$row["content"],$row["mDate"],$liked,$favourited,$likedByTitles[0],$likedByTitles[1]);
              array_push($comments,$comment);
            }
            return $comments;
          }
        }

        function addUserTagToComment($usersIds,$comment_id) {
            foreach ($usersIds as $user_id) {
                if ($user_id != 0) {
                    $this->queryUserTagToComment($user_id,$comment_id);
                }
            }
        }

        function queryUserTagToComment($user_id,$comment_id) {
            $query = "INSERT INTO inside_usertag (user_id,comment_id) VALUES ('$user_id','$comment_id')";
            $sth = $this->conn->prepare($query);
            $sth->execute();
        }

        // TaggedUserDB

        function getTaggedUserIdsBy($comment_id) {
            $query = "SELECT user_id FROM inside_usertag WHERE comment_id = '$comment_id' ORDER BY id ASC";
            $sth = $this->conn->prepare($query);

            $ids = array();
            if ($sth->execute()) {
                while ($row = $sth->fetch(PDO::FETCH_ASSOC)) {
                    array_push($ids,(int)$row['user_id']);
                }
            }
            return $ids;
        }

        function getTaggedUsernamesBy($comment_id) {
            $ids = $this->getTaggedUserIdsBy($comment_id);

            $usernames = array();
            foreach ($ids as $user_id) {
                $username = $this->queryTaggedUsernames($user_id);
                array_push($usernames,$username);
            }
            return $usernames;
        }

        function queryTaggedUsernames($user_id) {
            $user = new UsersAccountDB();
            $username = $user->getUsernameById($user_id);
            return $username;
        }

        function getMyCommentsBy($myUserId,$userId,$offset) {
            $query = "SELECT Comment.*,User.username,Liked.user_id AS liked_user_id,Favourite.user_id AS favourite_user_id FROM inside_comments AS Comment
                      JOIN inside_users AS User ON (Comment.author_id = User.id)
                      LEFT JOIN inside_userlikes AS Liked ON (Comment.id = Liked.comment_id AND Liked.user_id = $myUserId)
                      LEFT JOIN inside_userfavourites AS Favourite ON (Comment.id = Favourite.comment_id AND Favourite.user_id = $myUserId)
                      WHERE User.id = $userId ORDER BY mDate DESC LIMIT $this->limit OFFSET $offset";
            $sth = $this->conn->prepare($query);

            if ($sth->execute()) {
              $comments = array();
              while($row = $sth->fetch(PDO::FETCH_ASSOC)) {
                $liked = true;
                $favourited = true;

                if ($row["liked_user_id"] == NULL) {
                  $liked = false;
                }
                if ($row["favourite_user_id"] == NULL) {
                  $favourited = false;
                }
                $likedByTitles = $this->getCommentLikedByTitle($myUserId,$row["id"]);
                $comment = new Comment($row["id"],$row["author_id"],$row["username"],$row["content"],$row["mDate"],$liked,$favourited,$likedByTitles[0],$likedByTitles[1]);
                array_push($comments,$comment);
              }
              return $comments;
            }
        }

        function getCommentsWhereIamTagged($myUserId,$userId,$offset) {
            $query = "SELECT Comment.*,User.username,Liked.user_id as liked_user_id,Favourite.user_id AS favourite_user_id FROM inside_comments AS Comment
	                    JOIN inside_usertag AS UserTag ON (Comment.id = UserTag.comment_id)
	                    JOIN inside_users AS User ON (Comment.author_id = User.id)
	                    LEFT JOIN inside_userlikes AS Liked ON (Comment.id = Liked.comment_id AND Liked.user_id = $myUserId)
	                    LEFT JOIN inside_userfavourites AS Favourite ON (Comment.id = Favourite.comment_id AND Favourite.user_id = $myUserId)
	                    WHERE UserTag.user_id = $userId ORDER BY mDate DESC LIMIT $this->limit OFFSET $offset";
            $sth = $this->conn->prepare($query);

            if ($sth->execute()) {
              $comments = array();
              while($row = $sth->fetch(PDO::FETCH_ASSOC)) {
                $liked = true;
                $favourited = true;

                if ($row["liked_user_id"] == NULL) {
                  $liked = false;
                }
                if ($row["favourite_user_id"] == NULL) {
                  $favourited = false;
                }

                $likedByTitles = $this->getCommentLikedByTitle($myUserId,$row["id"]);
                $comment = new Comment($row["id"],$row["author_id"],$row["username"],$row["content"],$row["mDate"],$liked,$favourited,$likedByTitles[0],$likedByTitles[1]);
                array_push($comments,$comment);
              }
              return $comments;
            }
        }

        function deleteCommentByID($comment_id) {
            $query = "DELETE FROM inside_comments WHERE id = $comment_id";
            $sth = $this->conn->prepare($query);

            if ($sth->execute()) {
            	return $this->deleteTaggedUsersBy($comment_id);
            } else {
            	return false;
            }
        }

        private function getCommentLikedByTitle($myUserId,$commentId) {
          $usernames = $this->getFollowingLikeUsernamesTitle($myUserId,$commentId);
          $counting = $this->getCommentLikesCount($myUserId,$commentId);
          return array(0=>implode(',',$usernames),1=>(int)$counting);
        }

        private function getCommentLikesCount($myUserId,$commentId) {
          $query = "SELECT COUNT(*) AS counting FROM inside_userlikes WHERE comment_id = $commentId AND user_id != $myUserId";
          $sth = $this->conn->prepare($query);

          if($sth->execute()) {
            $row = $sth->fetch(PDO::FETCH_ASSOC);
            return $row['counting'];
          }
        }

        private function getFollowingLikeUsernamesTitle($myUserId,$commentId) {
          $query = "SELECT User.username FROM inside_users AS User
              JOIN inside_followers AS Follow ON (Follow.user_id = $myUserId)
              JOIN inside_userlikes AS Liked ON (Liked.user_id = Follow.following_id AND Liked.comment_id = $commentId)
              WHERE User.id = Follow.following_id LIMIT 2";
              $sth = $this->conn->prepare($query);
              $usernames = array();
              if ($sth->execute()) {
                while ($row = $sth->fetch(PDO::FETCH_ASSOC)) {
                 array_push($usernames,$row['username']);
            }
            return $usernames;
          }
        }

        // Likes \\

        function setLikeBy($user_id,$comment_id) {
            $query = "INSERT INTO inside_userlikes (user_id,comment_id) VALUES ($user_id,$comment_id)";
            $sth = $this->conn->prepare($query);
            try {
              $sth->execute();
              return true;
            } catch(Exception $e) {
              return false;
            }
        }

        function setUnLikeBy($user_id,$comment_id) {
            $query = "DELETE FROM inside_userlikes WHERE user_id = $user_id AND comment_id = $comment_id";
            $sth = $this->conn->prepare($query);

            if ($sth->execute()) {
              return true;
            }
            return false;
        }

        // Favourites \\

        function setFavourite($userId,$commentId) {
          $query = "INSERT INTO inside_userfavourites (user_id,comment_id) VALUES ($userId,$commentId)";
          $sth = $this->conn->prepare($query);
          try {
            $sth->execute();
            return true;
          } catch(Exception $e) {
            return false;
          }
        }

        function setUnFavourite($userId,$commentId) {
          $query = "DELETE FROM inside_userfavourites WHERE (user_id = $userId AND comment_id = $commentId)";
          $sth = $this->conn->prepare($query);

          if ($sth->execute()) {
            return true;
          }
          return false;
        }
     }


    // $row = $sth->fetch(PDO::FETCH_ASSOC);
