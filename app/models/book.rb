class Book < ApplicationRecord
 
  belongs_to :user
  has_many :favorites, dependent: :destroy
  # いいね順に並べる機能実装のため追記
  has_many :favorited_users, through: :favorites, source: :user
  # ここまで
  has_many :post_comments, dependent: :destroy
  
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
 
  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}
  
  # 検索方法分岐
  def self.looks(search, word)
    if search == "perfect_match"
      @book = Book.where("title LIKE?","#{word}")
    elsif search == "forward_match"
      @book = Book.where("title LIKE?","#{word}%")
    elsif search == "backward_match"
      @book = Book.where("title LIKE?","%#{word}")
    elsif search == "partial_match"
      @book = Book.where("title LIKE?","%#{word}%")
    else
      @book = Book.all
    end
  end
  
end
