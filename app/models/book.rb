class Book < ApplicationRecord
  
  is_impressionable counter_cache: true
 
  belongs_to :user
  has_many :favorites, dependent: :destroy
  # いいね順に並べる機能実装のため追記
  has_many :favorited_users, through: :favorites, source: :user
  # ここまで
  has_many :post_comments, dependent: :destroy
  
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
  
# 本の投稿数表示機能
# Day
  scope :created_today, -> { where(created_at: Time.zone.now.all_day) } # 今日
  scope :created_yesterday, -> { where(created_at: 1.day.ago.all_day) } # 前日
# Week
  scope :created_this_week, -> { where(created_at: 6.day.ago.beginning_of_day..Time.zone.now.end_of_day) } 
  scope :created_last_week, -> { where(created_at: 2.week.ago.beginning_of_day..1.week.ago.end_of_day) } 
# ここまで
 
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
