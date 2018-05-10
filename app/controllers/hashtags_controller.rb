class HashtagsController < ApplicationController

  def show
    @micropost = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end
end
