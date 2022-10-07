class Chat < ApplicationRecord
  belongs_to :user
  belongs_to :room
  
  validates :message,presence: true, length: {maximum: 140 } #空白ダメで、１４０字以内制限
end
