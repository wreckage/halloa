class UsersController < ApplicationController
  # before_action :authenticate_user!, only: [:show]

  def show
    user = User.find(params[:id])
    if user_signed_in?
      is_current_user = (user == current_user)
      is_following = current_user.following?(user)
    else
      is_current_user = false
      is_following = false
    end
    stat = Struct.new(:is_current_user, :is_following, :is_signed_in)
    status = stat.new(is_current_user, is_following, user_signed_in?)
    render component: "Profile", 
           props: { user: user.as_json(
                      only: [:id, :username, :gravatar_id], 
                      methods: [:followers_count, 
                                :following_count, 
                                :microposts_count]),
                    status: status }
  rescue ActiveRecord::RecordNotFound
    redirect_to root_url
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
