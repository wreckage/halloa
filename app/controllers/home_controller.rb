class HomeController < ApplicationController
  def index
    if user_signed_in?
      @user = current_user
      @json = { user: { id: @user.id, 
                        name: @user.name, 
                        gravatar_id: @user.gravatar_id } }
      render component: "HomeLoggedIn", props: ActiveSupport::JSON.encode(@json)
    else
      render component: "Home"
    end
  end
end
