require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  before { @user = FactoryGirl.create(:user_with_microposts) }

  describe "GET followers" do
    it "redirects followers when not signed in" do
      get :followers, { params: { id: @user.id } }
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe "GET following" do
    it "redirects following when not signed in" do
      get :following, { params: { id: @user.id } }
      expect(response).to redirect_to(new_user_session_path)
    end
  end

end
