class User < ApplicationRecord
  belongs_to :city
  has_many :gossips
  has_many :comments
  has_many :likes
  has_many :sent_messages, foreign_key: :sender_id, class_name: "PrivateMessage"
  has_many :private_message_recipients, foreign_key: :recipient_id
  has_many :received_messages, through: :private_message_recipients, source: :private_message
end
