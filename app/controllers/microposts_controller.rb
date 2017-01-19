class MicropostsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  #should allow for all logged in users
  def read
    @user = User.find(params[:id])
    if @user == current_user
      to_json = { next_page: @user.microposts.paginate(page: params[:page]).next_page,
                  microposts: @user.microposts.paginate(page: params[:page]).as_json(include: { user: { only: [:id, :username, :gravatar_id] } } )
      }
      respond_to do |format|
        format.json do
          render json: to_json
        end
        format.html do
          redirect_to root_url
        end
      end
    else
      redirect_to root_url
    end
  end

  def show
  end

  def create
    @micropost = current_user.microposts.build(micropost_params)
    respond_to do |format|
      format.json do
        if @micropost.save
          render json: ActiveSupport::JSON.encode({ success: "Post successful" })
        else
          render json: { errors: @micropost.errors.full_messages }, status: 422
        end
      end
    end
  end

  def update
  end

  def destroy
  end

  private 
    def micropost_params
      params.require(:micropost).permit(:content)
    end

end
