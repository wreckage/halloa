class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    render html: "Hello from the future home of user profile!"
  end
end
