class UsersController < ApplicationController
  def show
    if user_signed_in?
      @user = current_user
      render component: "Profile", 
        props: { user: @user.as_json(only: [:id, :username]), 
                 microposts_total: @user.microposts.count,
                 gravatar_id: @user.gravatar_id.as_json }
    else
      redirect_to root_url
    end
  end

  def index
    respond_to do |format|
      format.json do
        render json: { users: User.all.paginate(page: params[:page]).as_json(only: [:id, :username]),
                       next_page: User.all.paginate(page: params[:page]).next_page }
      end
      format.html do
        render component: "UserIndex"
      end
    end
  end

end
