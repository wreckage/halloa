class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:show]

  def show
    user = User.find(params[:id])
    is_current_user = false
    is_following = false
    if user_signed_in?
      is_current_user = (user == current_user)
      is_following = current_user.following?(user)
    end
    stat = Struct.new(:is_current_user, :is_following, :is_signed_in)
    status = stat.new(is_current_user, is_following, user_signed_in?)
    @props = { user: user_as_json(user), status: status }
    render component: "Profile", props: @props
  rescue ActiveRecord::RecordNotFound
    redirect_to root_url
  end

  def following
    build_follow_response("Following")
  end

  def followers
    build_follow_response("Followers")
  end

  def index
    respond_to do |format|
      format.json do
        @users = User.all.paginate(page: params[:page])
        render json: { 
          users: @users.as_json(only: [:id, :username, :gravatar_id]),
          next_page: @users.next_page }
      end
      format.html do
        render component: "UserIndex",
               props: { url: users_path,
                        title: "All Users",
                        user: nil }
      end
    end
  end

  private

    def user_as_json(user)
    return user.as_json(only: [:id, :username, :gravatar_id],
                        methods: [:followers_count,
                                  :following_count,
                                  :microposts_count])
    end

    # returns a Followers or Following component render, depending on follow_type
    def build_follow_response(follow_type)
      unless (follow_type == "Followers" || follow_type == "Following")
        return nil
      end
      return (
        respond_to do |format|
          format.json do
            users = User.find(params[:id]).public_send(follow_type.downcase).paginate(page: params[:page])
            @props = { users: users.as_json(only: [:id, :username, :gravatar_id]),
                       next_page: users.next_page }
            render json: @props
          end
          format.html do
            user = User.find(params[:id])
            user_json = user_as_json(user)
            path = follow_type == "Following" ? following_user_path(user) : followers_user_path(user)
            @props = { user: user_json, 
                       url: path, 
                       title: follow_type }
            render component: "UserIndex", props: @props
          end
        end
      )
    end
end
