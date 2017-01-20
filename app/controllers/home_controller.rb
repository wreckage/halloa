class HomeController < ApplicationController
  def index
    if user_signed_in?
      render component: "HomeLoggedIn", 
        props: { user: current_user.as_json(only: [:id, :username, :gravatar_id]), 
               micropost_total: current_user.microposts.count }
    else
      render component: "Home"
    end
  end
end
