<?php

    require_once '../messages/MessagesDB.php';
    
    class Message {
        
        protected $id;
        protected $sender_id;
        protected $receiver_id;
        protected $content;
        protected $reply_id;
        protected $chat_id;
        protected $date1;
        
        function __construct($id,$sender_id,$receiver_id,$content,$reply_id,$chat_id,$date1) {
            $this->id = $id;
            $this->sender_id = $sender_id;
            $this->receiver_id = $receiver_id;
            $this->content = $content;
            $this->reply_id = $reply_id;
            $this->chat_id = $chat_id;
            $this->date1 = $date1;
        }
        
        function toJson() {
            $message = new MessagesDB();
            $jsonArray = array(
                "id" => (int) $this->id,
                "sender_id" => (int) $this->sender_id,
                "receiver_id" => (int) $this->receiver_id,
                "content" => $this->content,
                "likes" => (int)$message->getLikesCount($this->id),
                "likedBySender" => (bool)$message->checkLikeFor($this->sender_id,$this->receiver_id,$this->id),
                "reply_id" => (int) $this->reply_id,
                "replyContent" => $message->getReplyContent($this->reply_id),
                "chat_id" => (int) $this->chat_id,
                "date" => $this->date1
                );
            return $jsonArray;
        }
    }