class HashtagsController < ApplicationController
def show
	@tag=Hashtag.find(params[:id])
	@microposts=@tag.microposts.paginate(page: params[:page])
end
end
