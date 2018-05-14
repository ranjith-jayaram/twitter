class HashtagsController < ApplicationController
def show
	@tag=Hashtag.find(params[:id])
	@microposts=@tag.microposts.paginate(page: params[:page])
end

def followers
    @title = "Followers"
    @tag  = Hashtag.find(params[:id])
    @users = @tag.followers.paginate(page: params[:page])
end

end
