class MicropostsController < ApplicationController
  #should allow for all logged in users
  def read
    @user = User.find(params[:id])
    if @user == current_user
      to_json = { microposts: @user.microposts.paginate(page: params[:page]).as_json,
                  next_page: @user.microposts.paginate(page: params[:page]).next_page }
      respond_to do |format|
        format.json do
          render json: to_json
        end
      end
    else
      redirect_to root_url
    end
  end

  def show
  end

  def create
  end

  def update
  end

  def destroy
  end
end
