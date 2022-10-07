class BooksController < ApplicationController
before_action :ensure_user,only: [:edit,:update,:destroy]

  def show
    @book = Book.find(params[:id])
    @user = @book.user
    @books = Book.new
    @post_comments = PostComment.all
    @post_comment = PostComment.new
    
    # 観覧数カウント
    impressionist(@book, nil, unique: [:ip_address]) # 追記
  end

  def index
    # @books = Book.all
    @book = Book.new
    # いいね順に並べるための追記
    to  = Time.current.at_end_of_day
    from  = (to - 6.day).at_beginning_of_day
    @books = Book.includes(:favorited_users).sort {|a,b| b.favorited_users.size <=> a.favorited_users.size}
    
     #観覧数カウント 
     @count_books = Book.order(impressions_count: 'DESC') # ソート機能を追加
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book.id), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.delete
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end
end


def ensure_user
  @books = current_user.books
  @book = @books.find_by(id: params[:id])  #.find_by:
  redirect_to books_path unless @book
end  