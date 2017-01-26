class HomeController < ApplicationController
  def index
    if user_signed_in?
      user = current_user.as_json(only: [:id, :username, :gravatar_id], 
                                  methods: [:followers_count, 
                                            :following_count, 
                                            :microposts_count])
      stat = Struct.new(:is_current_user, :is_following, :is_signed_in)
      status = stat.new(true, false, true)
      @props = { user: user, 
                 status: status,
                 fetchURL: user_feed_path(current_user), 
                 show_profile_link: true }
      render component: "Profile", props: @props
    else
      render component: "Home"
    end
  end
end
