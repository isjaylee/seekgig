class Message < ActiveRecord::Base
  belongs_to :user
  belongs_to :conversation
  belongs_to :recipient, foreign_key: :recipient_id, class_name: 'User'
end