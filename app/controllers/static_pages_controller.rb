class StaticPagesController < ApplicationController

  def home
    if logged_in?
      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
      @story_items = @feed_items.where("created_at > ?", Date.yesterday).where(picture: nil)
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end