class HomeController < ApplicationController
  def index
    if user_signed_in?
      @user = current_user
      @to_json = { user: { id: @user.id, 
                        name: @user.username } }
      render component: "HomeLoggedIn", props: ActiveSupport::JSON.encode(@to_json)
    else
      render component: "Home"
    end
  end
end
