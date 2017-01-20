class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:show]

  def show
    @user = User.find(params[:id])
    render component: "Profile", 
      props: { user: @user.as_json(only: [:id, :username, :gravatar_id]), 
               micropost_total: @user.microposts.count,
               is_current_user: (@user == current_user) }
  end

  def index
    respond_to do |format|
      format.json do
        render json: { users: User.all.paginate(page: params[:page]).as_json(only: [:id, :username, :gravatar_id]),
                       next_page: User.all.paginate(page: params[:page]).next_page }
      end
      format.html do
        render component: "UserIndex"
      end
    end
  end

end
