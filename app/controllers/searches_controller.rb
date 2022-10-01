class SearchesController < ApplicationController
before_action :authentical_user!

  def search
    @range = params[:range]
    
    if @range = "User"
      @users = User.looks(params[:search], params[:word])
    else
      @books = Book.looks(params[:search],params[:wo])
    end
  end
end
