class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books,dependent: :destroy
  has_many :favorites,dependent: :destroy
  has_many :post_comments,dependent: :destroy
  has_one_attached :profile_image
  
  #フォロー機能に関する関係
  has_many :relationships,foreign_key:"follower_id",dependent: :destroy
  has_many :reverse_of_relationships,class_name:"Relationship",foreign_key:"followed_id",dependent: :destroy
  
  #フォロー、一覧画面で使う
  has_many :followings, through: :relationships,source: :followed
  has_many :followers, through: :reverse_of_relationships,source: :follower
  
  #DM機能追加
  has_many :user_rooms,dependent: :destroy
  has_many :chats,dependent: :destroy
  has_many :rooms,through: :user_rooms  
  # ここまで
  
  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: {maximum: 50}
  
  def get_profile_image(weight,height)
    unless self.profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
    profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image_jpeg')
    end
    self.profile_image.variant(resize_to_fill: [weight, height]).processed
  end
  
  #フォローした時の処理
  def follow(user_id)
    relationships.create(followed_id: user_id)
  end
  
  #フォローを外す時の処理
  def unfolllow(user_id)
    relatinonships.find_by(followed_id: user_id).destroy
  end
  
  #フォローしているかの判定
  def following?(user)
    followings.include?(user)
  end
  
  # 検索方法分岐
  def self.looks(search,word)
    if search == "perfect_match"
      @user = User.where("name LIKE?", "#{word}")
    elsif search == "forward_match"
      @user = User.where("name LIKE?", "#{word}%")
     elsif search == "backward_match"
      @user = User.where("name LIKE?","%#{word}")
    elsif search == "partial_match"
      @user = User.where("name LIKE?","%#{word}%")
    else
      @user = User.all  
    end
  end
  
# ゲストログイン機能
   def self.guest
    find_or_create_by!(name: 'guestuser' ,email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "guestuser"
    end
  end
  
end
