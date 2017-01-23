class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:show]

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

  def following
    respond_to do |format|
      format.json do
        render json: { users: User.find(params[:id]).followers.paginate(page: params[:page]).as_json(only: [:id, :username, :gravatar_id]),
                       next_page: User.find(params[:id]).followers.paginate(page: params[:page]).next_page }
      end
      format.html do
        user = User.find(params[:id])
        # users = user.following.paginate(page: params[:page])
        render component: "UserIndex",
               props: { url: following_user_path(user),
                        title: "Following" }
      end
    end
  end

  def followers
    #user = User.find(params[:id])
    #users = user.followers.paginate(page: params[:page])
    #stat = Struct.new(:is_current_user, :title)
    #status = stat.new((user == current_user), "Followers")
    #render component: "Follows",
    #       props: { user: user.as_json(
    #                  only: [:id, :username, :gravatar_id], 
    #                  methods: [:followers_count, 
    #                            :following_count, 
    #                            :microposts_count]),
    #                users: users.as_json(only: [:id, :username, :gravatar_id]),
    #                status: status }
  end

  def index
    respond_to do |format|
      format.json do
        render json: { users: User.all.paginate(page: params[:page]).as_json(only: [:id, :username, :gravatar_id]),
                       next_page: User.all.paginate(page: params[:page]).next_page }
      end
      format.html do
        render component: "UserIndex",
               props: { url: users_path,
                        title: "All Users" }
      end
    end
  end

end
