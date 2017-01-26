class MicropostsController < ApplicationController
  before_action :authenticate_user!, except: [:read]
  before_action :check_format, only: [:read, :feed]

  # Responds with a user's feed in json format. Feed includes both a user's
  # microposts and all microposts by following users.
  def feed
    user = User.find(params[:id])
    following_ids = "SELECT followed_id FROM relationships
                     WHERE  follower_id = :user_id"
    microposts = Micropost.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: params[:id])
    microposts_json = microposts_as_json(microposts.paginate(page: params[:page]))
    next_page = microposts.paginate(page: params[:page]).next_page
    @package = { next_page: next_page,
                 microposts: microposts_json,
                 is_current_user: (user == current_user) }
    render json: @package
  end

  # Responds with a user's microposts in a json package
  def read
    user = User.find(params[:id])
    microposts_json = microposts_as_json(user.microposts.paginate(page: params[:page]))
    next_page = user.microposts.paginate(page: params[:page]).next_page
    @package = { microposts: microposts_json, next_page: next_page }
    render json: @package
  end

  def show
  end

  def create
    micropost = current_user.microposts.build(micropost_params_create)
    if micropost.save
      render json: { success: "Post successful" }, status: 201
    else
      render json: { errors: micropost.errors.full_messages }, status: 422
    end
  end

  def update
  end

  def destroy
    micropost = current_user.microposts.find_by(id: params[:id])
    if micropost.nil?
      render json: { errors: "Error: Could not destroy." }, status: 400
    else
      micropost.destroy
      render json: { success: "Destroy successful" }, status: 204
    end
  end

  private 
    def micropost_params_create
      params.require(:micropost).permit(:content)
    end

    def micropost_params_delete
      params.require(:micropost).permit(:id)
    end

    def microposts_as_json(microposts)
      microposts.as_json(include: { user: { only: [:id, :username, :gravatar_id] } } )
    end

    # Respond only to json requests. see http://stackoverflow.com/a/14579896
    def check_format
        redirect_to root_url unless params[:format] == 'json' || request.headers["Accept"] =~ /json/
    end
end
