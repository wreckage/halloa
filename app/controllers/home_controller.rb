class HomeController < ApplicationController
  def index
    if user_signed_in?
      render component: "HomeLoggedIn", 
             props: { user: current_user.as_json(
                        only: [:id, :username, :gravatar_id], 
                        methods: [:followers_count, 
                                  :following_count, 
                                  :microposts_count])}
    else
      render component: "Home"
    end
  end
end
