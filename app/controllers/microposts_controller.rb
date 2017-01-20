class MicropostsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_format, only: [:read]

  def feed
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

    # Respond only to json requests. see http://stackoverflow.com/a/14579896
    def check_format
        redirect_to root_url unless params[:format] == 'json' || request.headers["Accept"] =~ /json/
    end


end
