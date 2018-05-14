class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    if params[:followed_type]=="User"
    @user = User.find_by(id: params[:followed_id])
    current_user.follow(@user, "User")
      respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
    elsif params[:followed_type]=="Hashtag"
    @tag = Hashtag.find_by(id: params[:followed_id])
    current_user.follow(@tag, "Hashtag")
     respond_to do |format|
      format.html { redirect_to @tag }
      format.js
    end 
    elsif params[:followed_type]=="Micropost"
    @micropost = Micropost.find_by(id: params[:followed_id])
    @hi=current_user.follow(@micropost, "Micropost")
     respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end 
  end

  end

  def destroy
  if params[:followed_type]=="User"
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow_user(@user)
      respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  elsif params[:followed_type]=="Hashtag"
    @tag = Relationship.find(params[:id]).followed
    current_user.unfollow_hashtag(@tag)
      respond_to do |format|
      format.html { redirect_to @tag }
      format.js
    end
  elsif params[:followed_type]=="Micropost"
    @micropost = Relationship.find(params[:id]).followed
    current_user.unfollow_micropost(@micropost)
      respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  end
end