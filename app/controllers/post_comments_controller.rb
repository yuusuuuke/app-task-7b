class PostCommentsController < ApplicationController

  def create
    book = Book.find(params[:book_id])
    comment = current_user.post_comments.new(post_comment_params)
    comment.book_id = book.id
    comment.save
    @post_comments = PostComment.all
  end
  
  def destroy
    comment = PostComment.find(params[:book_id])
    if comment.user_id != current_user.id
      render :show
    end
    comment.destroy
  end

private
  def post_comment_params
    params.require(:post_comment).permit(:comment)
  end

end