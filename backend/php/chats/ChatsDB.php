<?php

    require_once '../models/Chat.php';
    require_once '../user/UsersAccountDB.php';
    require_once '../messages/MessagesDB.php';

    class ChatsDB {

        protected $conn;

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

        function createChat($sender_id,$receiver_id) {
            if ($this->checkExistence($sender_id,$receiver_id)) {
                return;
            }
            $query = "INSERT INTO inside_chats (sender_id,receiver_id) VALUES ($sender_id,$receiver_id)";
            $sth = $this->conn->prepare($query);

            if ($sth->execute()) {
                return $this->conn->lastInsertId();
            } else {
                return -1;
            }
        }

        function getChatsBy($userId) {
            $query = "SELECT user.*,chat.* FROM inside_chats AS chat
                        JOIN inside_users AS user ON (user.id = chat.receiver_id)
            WHERE chat.sender_id = $userId OR chat.receiver_id = $userId";
            $sth = $this->conn->prepare($query);

            if ($sth->execute()) {
                $chats = array();
                while($row = $sth->fetch(PDO::FETCH_ASSOC)) {
                    $chat = new Chat($row['id'],$row['sender_id'],$row['receiver_id'],$row['username']);
                    array_push($chats,$chat);
                }
                return $chats;
            }
        }

        function delete($chat_id) {
            $query = "DELETE FROM inside_chats WHERE id = $chat_id";
            $sth = $this->conn->prepare($query);

            if ($sth->execute()) {
                return  $this->deleteAllMessages($chat_id);;
            } else {
                return false;
            }
        }

        private function checkExistence($sender_id,$receiver_id) {
            $query = "SELECT id FROM inside_chats WHERE sender_id = $sender_id AND receiver_id = $receiver_id";
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

        private function deleteAllMessages($chat_id) {
            $message = new MessagesDB();
            $message->deleteMessagesBy($chat_id);
        }

        function uploadImage($chat_id) {
            $target_dir = "../../chats_data/".$chat_id;

            if(!file_exists($target_dir)) {
                mkdir($target_dir, 0777, true);
            }

            $target_dir = $target_dir . "/" . basename($_FILES["file"]["name"]);

            if (move_uploaded_file($_FILES["file"]["tmp_name"], $target_dir)) {
                return true;
            }
            return false;
        }

        function deleteImageForChat($chat_id,$message_id) {
            $target_dir = "../../chats_data/".$chat_id."/IMG".$message_id;
            unlink($target_dir);
        }

        function searchMyChats($input,$userId) {
            $query = "SELECT user.*,chat.* FROM inside_users AS user
                        JOIN inside_chats AS chat ON (user.username LIKE '$input%' OR '%$input')
                        WHERE ( (user.id = chat.receiver_id AND chat.sender_id = $userId) OR (user.id = chat.sender_id AND chat.receiver_id = $userId) )";

            $sth = $this->conn->prepare($query);

            if ($sth->execute()) {
                $chats = array();
                while ($row = $sth->fetch(PDO::FETCH_ASSOC)) {
                    $chat = new Chat($row['id'],$row['sender_id'],$row['receiver_id'],$row['username']);
                    array_push($chats,$chat);
                }
                return $chats;
            }
        }
    }





// $row = $sth->fetch(PDO::FETCH_ASSOC);
