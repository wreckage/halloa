class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    user = User.find(params[:followed_id])
    current_user.follow(user)
    render json: { success: "Follow successful" }, status: 201
  end

  def destroy
    user = User.find(params[:followed_id])
    current_user.unfollow(user)
    render json: { success: "Unfollow successful" }, status: 201
  end
end
