class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:update,:edit]
  before_action :ensure_guest_user, only: [:edit]
  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
    # コメント数集計、前日比較機能
    # Day
    @today_book = @books.created_today
    @yesterday_book = @books.created_yesterday
    
    # Week
    @this_week_book = @books.created_this_week
    @last_week_book = @books.created_last_week
    # ここまで
  end

  def index
    @users = User.all
    @book = Book.new
    @user = User.where.not(id: current_user.id)
  end
  
  def followings
    user = User.find(params[:id])
    @users = user.followings
  end
  
  def followers
    user = User.find(params[:id])
    @users = user.followers
  end
  

  def edit
    @user = User.find(params[:id])
    #if @user != current_user
    #  redirect_to user_path(@user.id)
    #end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user.id), notice: "You have updated user successfully."
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
  
  def ensure_guest_user
    @user = User.find(params[:id])
    if @user.name == "guestuser"
      redirect_to user_path(current_user) , notice: 'ゲストユーザーはプロフィール編集画面へ遷移できません。'
    end
  end  
  
end
