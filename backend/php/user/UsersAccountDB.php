<?php

    require_once '../models/User.php';
    require_once 'UserNetwork.php';

    class UsersAccountDB {

        protected $conn;
        protected $limit = 16;

        function __construct() {
            $servername = "localhost";
            $username = "xs3xws6r_finix";
            $password = "0AFfi1iWrSlkGtIrZ";
            $databaseName = "xs3xws6r_inside";

            try {
                $this->conn = new PDO("mysql:host=$servername;dbname=$databaseName", $username, $password);
                $this->conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

            } catch(PDOException $e) {
              echo "Connection failed: " . $e->getMessage();
            }
        }

        function __destruct() {
            $this->conn = NULL;
        }

        function emailAlreadyExists($email) { // false - non esiste
            $query = "SELECT id FROM inside_users WHERE email = '$email'";
            $sth = $this->conn->prepare($query);

            if ($sth->execute()) {
                $row = $sth->fetch(PDO::FETCH_ASSOC);

                if (empty($row)) {
                    return false;
                } else {
                    return true;
                }
            }
        }

        function usernameAlreadyExists($username) { // false - non esiste
            $query = "SELECT id FROM inside_users WHERE username = '$username'";
            $sth = $this->conn->prepare($query);

            if ($sth->execute()) {
                $row = $sth->fetch(PDO::FETCH_ASSOC);

                if (empty($row)) {
                    return false;
                } else {
                    return true;
                }
            }
        }

        function register($username,$email,$password) {
            $query = "INSERT INTO inside_users (username,email,password) VALUES ('$username','$email','$password')";
            $sth = $this->conn->prepare($query);
            $sth->execute();
        }

        function login($username,$password) {
            $query = "SELECT id,username,email,bio,webSite,instagram FROM inside_users WHERE ((username = '$username' || email = '$username') AND password = '$password')";
            $sth = $this->conn->prepare($query);

            if ($sth->execute()) {
                $row = $sth->fetch(PDO::FETCH_ASSOC);
                if (empty($row)) {
                    return array();
                } else {
                    return new User($row['id'],$row['username'],$row['email'],"",$row['bio'],$row['webSite'],$row['instagram']);
                }
            }
        }

        function followAlreadyExists($user_id,$follower_id) {
            $query = "SELECT id FROM inside_followers WHERE (user_id = '$user_id' AND following_id = '$follower_id')";
            $sth = $this->conn->prepare($query);

            if ($sth->execute()) {
                $row = $sth->fetch(PDO::FETCH_ASSOC);

                if (empty($row)) {
                    return false;
                } else {
                    return true;
                }
            } else {
                return true;
            }
        }

        function addFollower($user_id,$follower_id) {
            $followerAlreadyExists = $this->followAlreadyExists($user_id,$follower_id);

            if(!$followerAlreadyExists) {
                $query = "INSERT INTO inside_followers (user_id,following_id) VALUES ('$user_id','$follower_id')";
                $sth = $this->conn->prepare($query);
                $sth->execute();
            }
        }

        function removeFollower($user_id,$follower_id) {
            $query = "DELETE FROM inside_followers WHERE user_id = '$user_id' AND following_id = '$follower_id'";
            $sth = $this->conn->prepare($query);
            $sth->execute();
        }

        function getUserFollowers($userId,$mainUserId,$offset) {
            $query = "SELECT DISTINCT follower.*, user.* FROM inside_followers AS follower
                        JOIN inside_users AS user ON (follower.following_id = $userId)
                            WHERE user.id = follower.user_id LIMIT $this->limit OFFSET $offset";
            $sth = $this->conn->prepare($query);

            if ($sth->execute()) {
                $users = array();
                while ($row = $sth->fetch(PDO::FETCH_ASSOC)) {
                    $followBack = $this->followBack($row['id'],$mainUserId);
                    $user = new User($row['id'],$row['username'],$row['name'],"",$row['bio'],$row['link'],$row['instagram'],$followBack);
                    array_push($users,$user);
                }
                return $users;
            }
        }

        function getUserFollowing($userId,$mainUserId,$offset) {
            $query = "SELECT DISTINCT follower.*, user.* FROM inside_followers AS follower
                        JOIN inside_users AS user ON (follower.user_id = $userId)
                            WHERE user.id = follower.following_id LIMIT $this->limit OFFSET $offset";
            $sth = $this->conn->prepare($query);

            if ($sth->execute()) {
                $users = array();
                while ($row = $sth->fetch(PDO::FETCH_ASSOC)) {
                    $followBack = $this->followBack($row['id'],$mainUserId);
                    $user = new User($row['id'],$row['username'],$row['name'],"",$row['bio'],$row['link'],$row['instagram'],$followBack);
                    array_push($users,$user);
                }
                return $users;
            }
        }

        function followBack($user_id,$follower_id) {
            $query = "SELECT id FROM inside_followers WHERE user_id = '$follower_id' AND following_id = '$user_id'";
            $sth = $this->conn->prepare($query);

            if ($sth->execute()) {
                $row = $sth->fetch(PDO::FETCH_ASSOC);

                if (empty($row)) {
                    return false;
                } else {
                    return true;
                }
            }
            return false;
        }

        function getFollowerCount($user_id) {
            $query = "SELECT
                        (SELECT COUNT(*) FROM inside_followers WHERE user_id='$user_id') AS following,
                        (SELECT COUNT(*) FROM inside_followers WHERE following_id='$user_id') AS followers
                        FROM inside_followers";


            $sth = $this->conn->prepare($query);

            $counts = array();
            if ($sth->execute()) {
                $row = $sth->fetch(PDO::FETCH_ASSOC);

                array_push($counts, $row['followers']);
                array_push($counts,$row['following']);
            } else {

            }

            return $counts;
        }

        function getUsername($user_id) {
            $query = "SELECT username FROM inside_users WHERE id = $user_id";
            $sth = $this->conn->prepare($query);

            if ($sth->execute()) {
                $row = $sth->fetch(PDO::FETCH_ASSOC);
                return $row['username'];
            }
        }

        function uploadImage($userId) {
            $target_dir = "../../usersData/".$userId;

            if(!file_exists($target_dir)) {
                mkdir($target_dir, 0755, true);
            }

            $target_dir = $target_dir . "/" . basename($_FILES["file"]["name"]);

            if (move_uploaded_file($_FILES["file"]["tmp_name"], $target_dir)) {
                return true;
            } else {
                return false;
            }
        }

        function checkUniqueFor($user_id,$username) {
            $query = "SELECT id FROM inside_users WHERE (username = '$username' AND id != $user_id)";
            $sth = $this->conn->prepare($query);

            if ($sth->execute()) {
                $row = $sth->fetch(PDO::FETCH_ASSOC);

                if (empty($row)) {
                    return true;
                } else {
                    return false;
                }
            }
        }

        function editUserData($userId,$username,$name,$bio,$instagram,$link) {
            $query = "UPDATE inside_users SET username = '$username', name = '$name', bio = '$bio', instagram = '$instagram', link = '$link' WHERE id = $userId";
            $sth = $this->conn->prepare($query);

            if ($sth->execute()) {
                return true;
            }
            return false;
        }

        function setUsernameBy($user_id,$username) {
            $query = "UPDATE inside_users SET username = '$username' WHERE id = '$user_id'";
            $sth = $this->conn->prepare($query);

            if ($this->checkUniqueFor($user_id,$username)) {
                if ($sth->execute()) {
                    return true;
                } else {
                    return false;
                }
            } else {
                return false;
            }
        }

        function setUserBioBy($user_id,$user_bio) {
            $query = "UPDATE inside_users SET bio = '$user_bio' WHERE id = '$user_id'";
            $sth = $this->conn->prepare($query);

            if ($sth->execute()) {
                return true;
            } else {
                return false;
            }
        }

        function setUserNewPassword($user_id,$new_password) {
            $query = "UPDATE inside_users SET password = '$new_password' WHERE id = '$user_id'";
            $sth = $this->conn->prepare($query);

            if ($sth->execute()) {
                return true;
            } else {
                return false;
            }
        }

        function setupUserInstagram($user_id,$instagram) {
            $query = "UPDATE inside_users SET instagram = '$instagram' WHERE id = '$user_id'";
            $sth = $this->conn->prepare($query);

            if ($sth->execute()) {
                return true;
            } else {
                return false;
            }
        }

        function checkUserCurrentPassword($user_id,$current_password,$new_password) {
            $query = "SELECT id FROM inside_users WHERE password = '$current_password' AND id = '$user_id'";
            $sth = $this->conn->prepare($query);

            if ($sth->execute()) {
                $row = $sth->fetch(PDO::FETCH_ASSOC);
                if (!empty($row)) {
                    return $this->setUserNewPassword($user_id,$new_password);
                } else {
                    return false;
                }
            }
        }

        function getTaggedUserIdBy($username) {
            $query = "SELECT id FROM inside_users WHERE username = '$username'";
            $sth= $this->conn->prepare($query);

            if ($sth->execute()) {
                $row = $sth->fetch(PDO::FETCH_ASSOC);
                return $row['id'];
            } else {
                return NULL;
            }
        }

        function getTaggedUserIdsBy($usernames) {
            $userIds = array();
            foreach ($usernames as $username) {
                $id = $this->getTaggedUserIdBy($username);
                if ($id != NULL) {
                    array_push($userIds,$id);
                } else {
                    array_push($userIds,0);
                }
            }
            return $userIds;
        }

        function getUsernameById($user_id) {
            $query = "SELECT username FROM inside_users WHERE id = '$user_id'";
            $sth = $this->conn->prepare($query);

            if ($sth->execute()) {
                $row = $sth->fetch(PDO::FETCH_ASSOC);
                return $row['username'];
            } else {
                return "";
            }
        }

        function getUserBy($my_user_id,$user_id) {
            $query = "SELECT * FROM inside_users WHERE id = '$user_id'";
            $sth = $this->conn->prepare($query);

            if ($sth->execute()) {
                $row = $sth->fetch(PDO::FETCH_ASSOC);
                $followBack = $this->followBack($user_id,$my_user_id);
                $user = new UserFollow($row['id'],$row['username'],$row['email'],"",$row['bio'],$row['webSite'],$row['instagram'],$followBack);
                return $user;
            }
        }

        function searchUsers($user_id,$input,$offset) {
            $query = "SELECT * FROM inside_users WHERE username LIKE '$input%' AND id != $user_id LIMIT $this->limit OFFSET $offset"; // OR username LIKE '$input%'
            $sth = $this->conn->prepare($query);

            if ($sth->execute()) {
                $users = array();
                while ($row = $sth->fetch(PDO::FETCH_ASSOC)) {
                    $followBack = $this->followBack($row['id'],$user_id);
                    $user = new User($row['id'],$row['username'],$row['name'],"",$row['bio'],$row['link'],$row['instagram'],$followBack);
                    array_push($users,$user);
                }
                return $users;
            }
        }

        function searchFollowers($user_id,$input) {
            $query = "SELECT * FROM inside_users WHERE id IN (SELECT user_id FROM inside_followers WHERE following_id = '$user_id') AND (username LIKE '$input%' OR '%$input')";
            $sth = $this->conn->prepare($query);

            if ($sth->execute()) {
                $users = array();

                while ($row = $sth->fetch(PDO::FETCH_ASSOC)) {
                    $followBack = $this->followBack($row['id'],$user_id);
                    $user = new UserFollow($row['id'],$row['username'],$row['email'],"",$row['bio'],$row['webSite'],$row['instagram'],$followBack);
                    array_push($users,$user);
                }
            }
            return $users;
        }

        function searchFollowing($user_id,$input) {
            $query = "SELECT * FROM inside_users WHERE id IN (SELECT following_id FROM inside_followers WHERE user_id = $user_id) AND (username LIKE '$input%' OR '%$input')";
            $sth = $this->conn->prepare($query);

            if ($sth->execute()) {
                $users = array();

                while ($row = $sth->fetch(PDO::FETCH_ASSOC)) {
                    $followBack = $this->followBack($user_id,$row['id']);
                    $user = new UserFollow($row['id'],$row['username'],$row['email'],"",$row['bio'],$row['webSite'],$row['instagram'],$followBack);
                    array_push($users,$user);
                }
            }
            return $users;
        }

        function selectAllUsers() {
            $query = "SELECT * FROM inside_users";
            $sth = $this->conn->prepare($query);

            if ($sth->execute()) {
                $row = $sth->fetch(PDO::FETCH_ASSOC);
                return new User($row['id'],$row['username'],$row['email'],"",$row['bio'],$row['webSite'],$row['instagram']);
            }
        }

        function getNameAndEmailBy($user_id) {
            $query = "SELECT username, email FROM inside_users WHERE id = $user_id";
            $sth = $this->conn->prepare($query);

            if ($sth->execute()) {
                $row = $sth->fetch(PDO::FETCH_ASSOC);
                return array("username"=>$row['username'],"email"=>$row['email']);
            }
            return [];
        }

        function getSuggestedUsers($userId,$offset) {
            $query = "SELECT DISTINCT user.* FROM inside_users AS user
                        JOIN inside_followers AS following_1 ON (user.id = following_1.following_id)
                        JOIN inside_followers AS following_2 ON (following_1.user_id = following_2.following_id)
                        WHERE (following_2.user_id = $userId AND user.id NOT IN
                        (SELECT following_3.following_id FROM inside_followers AS following_3 WHERE following_3.user_id = $userId)
                        AND user.id != $userId) ORDER BY RAND() LIMIT $this->limit OFFSET $offset";
            $sth = $this->conn->prepare($query);

            if ($sth->execute()) {
                $users = array();
                while ($row = $sth->fetch(PDO::FETCH_ASSOC)) {
                    $followBack = $this->followBack($userId,$row['id']);
                    $user = new User($row['id'],$row['username'],$row['name'],"",$row['bio'],$row['link'],$row['instagram'],$followBack);
                    array_push($users,$user);
                }
                return $users;
            }
        }

        function editPassword($userId,$oldPassword,$newPassword) {
          $query = "SELECT count(*) AS count FROM inside_users WHERE (id = $userId AND password = '$oldPassword')";
          $sth = $this->conn->prepare($query);

          if ($sth->execute()) {
            $row = $sth->fetch(PDO::FETCH_ASSOC);
            if ($row["count"] > 0) { // current password match the oldest one.
              $query = "UPDATE inside_users SET password = '$newPassword' WHERE id = $userId";
              $sth = $this->conn->prepare($query);
              if ($sth->execute()) {
                return true;
              }
              return false;
            }
            return false;
          }
        }

        function getUserByUsername($username,$userId) {
          $query = "SELECT * FROM inside_users WHERE username = '$username'";
          $sth = $this->conn->prepare($query);

          if ($sth->execute()) {
            $row = $sth->fetch(PDO::FETCH_ASSOC);
            $followBack = $this->followBack($row['id'],$userId);
            $user = new User($row['id'],$row['username'],$row['name'],"",$row['bio'],$row['link'],$row['instagram'],$followBack);
            return $user;
          }
        }

        function getUserById($myUserId,$userId) {
          $query = "SELECT * FROM inside_users WHERE id = $userId";
          $sth = $this->conn->prepare($query);

          if ($sth->execute()) {
            $row = $sth->fetch(PDO::FETCH_ASSOC);
            $followBack = $this->followBack($row['id'],$myUserId);
            $user = new User($row['id'],$row['username'],$row['name'],"",$row['bio'],$row['link'],$row['instagram'],$followBack);
            return $user;
          }
        }

        function followUser($userId,$followingId) {
          $query = "INSERT INTO inside_followers (user_id,following_id) VALUES ('$userId','$followingId')";
          $sth = $this->conn->prepare($query);

          try {
            $sth->execute();
            return true;
          } catch(Exception $e) {
            return false;
          }
        }

        function unfollowUser($userId,$followingId) {
          $query = "DELETE FROM inside_followers WHERE user_id = '$userId' AND following_id = '$followingId'";
          $sth = $this->conn->prepare($query);

          if ($sth->execute()) {
            return true;
          }
          return false;
        }

        // this function return users in liked by @..
        function getUsersLikedComment($userId,$commentId,$offset) {
          $query = "SELECT User.* FROM inside_users AS User
	                   JOIN inside_comments AS Comment ON (Comment.id = $commentId)
	                    JOIN inside_followers AS Follow ON (Follow.user_id = $userId)
	                     JOIN inside_userlikes AS Liked ON (Liked.user_id = Follow.following_id AND liked.comment_id = $commentId)
	                      WHERE User.id = Follow.following_id
	                       UNION
                         SELECT User.* FROM inside_users AS User
	                        JOIN inside_comments AS Comment ON (Comment.id = $commentId)
	                          JOIN inside_userlikes AS Liked ON (Liked.user_id != $userId AND liked.comment_id = $commentId)
	                           WHERE User.id = Liked.user_id LIMIT $this->limit OFFSET $offset";

          $sth = $this->conn->prepare($query);
          if ($sth->execute()) {
            $users = array();
            while ($row = $sth->fetch(PDO::FETCH_ASSOC)) {
              $followBack = $this->followBack($row['id'],$userId);
              $user = new User($row['id'],$row['username'],$row['name'],"",$row['bio'],$row['link'],$row['instagram'],$followBack);
              array_push($users,$user);
            }
            return $users;
          }
        }

        function getRecentUsers($myUserId,$userIds) {
          $users = array();
          foreach($userIds as $userId) {
            $user = $this->queryRecentUsers($myUserId,$userId);
            if ($user != NULL) {
              array_push($users,$user);
            }
          }
          return $users;
        }

        private function queryRecentUsers($myUserId,$userId) {
          $query = "SELECT * FROM inside_users WHERE id = $userId";
          $sth = $this->conn->prepare($query);

          if($sth->execute()) {
            $row = $sth->fetch(PDO::FETCH_ASSOC);
            $followBack = $this->followBack($row['id'],$myUserId);

            if($row['id'] != 0) {
              return new User($row['id'],$row['username'],$row['name'],"",$row['bio'],$row['link'],$row['instagram'],$followBack);
            }
            return NULL;
          }
        }

        function getFollowedBy($myUserId,$userId,$limit,$offset) {
          $query = "SELECT User.* FROM inside_users AS User
                     JOIN inside_followers AS Follow ON (Follow.user_id = $myUserId)
                     JOIN inside_followers AS Follow1 ON (Follow1.user_id = Follow.following_id AND Follow1.following_id = $userId)
                     WHERE User.id = Follow.following_id LIMIT $limit OFFSET $offset";
          $sth = $this->conn->prepare($query);

          if ($sth->execute()) {
            $users = array();
            while ($row = $sth->fetch(PDO::FETCH_ASSOC)) {
              $user = new User($row['id'],$row['username'],$row['name'],"",$row['bio'],$row['link'],$row['instagram'],true);
              array_push($users,$user);
            }
            return $users;
          }
        }

        function getFollowedByTitle($myUserId,$userId,$limit,$offset) {
          $users = $this->getFollowedBy($myUserId,$userId,$limit,$offset);
          $counting = $this->getFollowedByCount($myUserId,$userId);
          $usernames = array();

          foreach($users as $user) {
            array_push($usernames,$user->getUsername());
          }
          return array("usernames"=>$usernames,"counting"=>(int)$counting);
        }

       private function getFollowedByCount($myUserId,$userId) {
        $query = "SELECT COUNT(*) AS counting FROM inside_users AS User
	                JOIN inside_followers AS Follow ON (Follow.user_id = $myUserId)
	                JOIN inside_followers AS Follow1 ON (Follow1.user_id = Follow.following_id AND Follow1.following_id = $userId)
	                WHERE User.id = Follow.following_id";
        $sth = $this->conn->prepare($query);

        if ($sth->execute()) {
          $row = $sth->fetch(PDO::FETCH_ASSOC);
          return $row['counting'];
        }
        return -1;
      }
    }



















    // AND (user_id = $userId AND follower_id = $followerId))
    // $row = $sth->fetch(PDO::FETCH_ASSOC);
