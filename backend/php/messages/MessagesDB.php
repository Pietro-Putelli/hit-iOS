<?php

    require_once '../models/Message.php';
    require_once '../user/UsersAccountDB.php';

    class MessagesDB {
        
        protected $conn;
        
        function __construct() {
            $servername = "localhost";
            $username = "xs3xws6r_finix";
            $password = "0AFfi1iWrSlkGtIrZ";
            $databaseName = "xs3xws6r_inside";
        
            try {
                $this->conn = new PDO("mysql:host=$servername;dbname=$databaseName", $username, $password);
                $this->conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
                } 
                catch(PDOException $e) {
                    echo "Connection failed: " . $e->getMessage();
                }
            }
        
        function __destruct() {
            $this->conn = NULL;
        }
        
        function setMessage($sender_id,$receiver_id,$content,$reply_id,$chat_id,$date) {
            $query = "INSERT INTO inside_messages (sender_id, receiver_id, content, reply_id, chat_id, date) VALUES ('$sender_id','$receiver_id','$content','$reply_id','$chat_id','$date')";
            $sth = $this->conn->prepare($query);
            
            if ($sth->execute()) {
                return $this->conn->lastInsertId();
            } else {
                return -1;
            }
        }
        
        function getMessagesBy($chat_id,$limit,$offSet) {
            $query = "SELECT * FROM inside_messages WHERE chat_id = '$chat_id' ORDER BY id DESC LIMIT $limit OFFSET $offSet";
            $sth = $this->conn->prepare($query);
            
            if ($sth->execute()) {
                $messages = array();
                while($row = $sth->fetch(PDO::FETCH_ASSOC)) {
                    $message = new Message($row['id'],$row['sender_id'],$row['receiver_id'],$row['content'],$row['reply_id'],$row['chat_id'],$row['date']);
                    array_push($messages,$message);
                }
                return $messages;
            }
            return false;
        }
        
        function getAllMessagesBy($chat_id) {
            $query = "SELECT * FROM inside_messages WHERE chat_id = $chat_id ORDER BY id DESC";
            $sth = $this->conn->prepare($query);
            
            if ($sth->execute()) {
                $messages = array();
                while($row = $sth->fetch(PDO::FETCH_ASSOC)) {
                    $message = new Message($row['id'],$row['sender_id'],$row['receiver_id'],$row['content'],$row['reply_id'],$row['chat_id'],$row['date']);
                    array_push($messages,$message);
                }
                return $messages;
            }
            return false;
        }
        
        function getReplyContent($reply_id) {
            $query = "SELECT content FROM inside_messages WHERE id = $reply_id";
            $sth = $this->conn->prepare($query);
            
            if ($sth->execute()) {
                $replyContent = $sth->fetch(PDO::FETCH_ASSOC)['content'];
                
                if ($replyContent == NULL) {
                    return "";
                } else {
                    return $replyContent;
                }
            } else {
                return "";
            }
        }
        
        function deleteMessageBy($message_id) {
            $query = "DELETE FROM inside_messages WHERE id = $message_id";
            $sth = $this->conn->prepare($query);
            
            if ($sth->execute()) {
                return true;
            }
            return false;
        }
        
        function deleteMessagesBy($chat_id) {
            $query = "DELETE FROM inside_messages WHERE chat_id = $chat_id";
            $sth = $this->conn->prepare($query);
            $sth->execute();
        }
        
        function deleteReadMessages($chat_id,$user_id) {
            $query = "DELETE FROM inside_messages WHERE chat_id = $chat_id AND sender_id != $user_id";
            $sth = $this->conn->prepare($query);
            $sth->execute();
        }
        
        function addLike($message_id,$user_id) {
            $query = "INSERT INTO inside_messages_likes (message_id,user_id) VALUES ($message_id,$user_id)";
            $sth = $this->conn->prepare($query);
            $sth->execute();
        }
        
        function removeLike($message_id,$user_id) {
            $query = "DELETE FROM inside_messages_likes WHERE user_id = $user_id AND message_id = $message_id";
            $sth = $this->conn->prepare($query);
            $sth->execute();
        }
        
        function getLikesCount($message_id) {
            $query = "SELECT COUNT(id) AS count FROM inside_messages_likes WHERE message_id = $message_id";
            $sth = $this->conn->prepare($query);
            
            if ($sth->execute()) {
                $row = $sth->fetch(PDO::FETCH_ASSOC);
                return $row['count'];
            }
            return -1;
        }
        
        function checkLikeFor($sender_id,$receiver_id,$message_id) {
            $query = "SELECT id FROM inside_messages_likes WHERE message_id = $message_id AND (user_id = $sender_id OR user_id = $receiver_id)";
            $sth = $this->conn->prepare($query);
            
            if ($sth->execute()) {
                $row = $sth->fetch(PDO::FETCH_ASSOC);
                return !(empty($row));
            }
            return false;
        }
    }
    
    
    
    
    
    
    
    