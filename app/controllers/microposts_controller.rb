class MicropostsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_format, only: [:read, :feed]

  def feed
    user = User.find(params[:id])
    to_json = { next_page: Micropost.where("user_id = ?", user.id).paginate(page: params[:page]).next_page,
                microposts: Micropost.where("user_id = ?", user.id).paginate(page: params[:page]).as_json(include: { user: { only: [:id, :username, :gravatar_id] } } ),
               is_current_user: (user == current_user) }
    render json: to_json
  end

  def read
    @user = User.find(params[:id])
    to_json = { next_page: @user.microposts.paginate(page: params[:page]).next_page,
                microposts: @user.microposts.paginate(page: params[:page]).as_json(include: { user: { only: [:id, :username, :gravatar_id] } } )
    }
    render json: to_json
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

    # Respond only to json requests. see http://stackoverflow.com/a/14579896
    def check_format
        redirect_to root_url unless params[:format] == 'json' || request.headers["Accept"] =~ /json/
    end


end
