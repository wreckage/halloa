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
end
