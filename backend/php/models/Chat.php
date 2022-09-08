<?php

    class Chat {
        
        protected $id;
        protected $sender_id;
        protected $receiver_id;
        protected $receiver_name;
        
        function __construct($id,$sender_id,$receiver_id,$receiver_name) {
            $this->id = $id;
            $this->sender_id = $sender_id;
            $this->receiver_id = $receiver_id;
            $this->receiver_name = $receiver_name;
        }
        
        function toArray() {
            return array(
                "id" => (int) $this->id,
                "senderId" => (int) $this->sender_id,
                "receiverId" => (int) $this->receiver_id,
                "username" => $this->receiver_name
            );
        }
    }