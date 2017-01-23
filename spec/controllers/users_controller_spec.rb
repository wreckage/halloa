require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  before { @user = FactoryGirl.create(:user_with_microposts) }

  describe "GET followers (not signed in)" do
    it "redirects followers when not signed in" do
      get :followers, { params: { id: @user.id } }
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe "GET followers while signed in" do
    before { sign_in @user }
    it "responds to html by default" do
      get :followers, { params: { id: @user.id } }
      expect(response.content_type).to eq "text/html"
      expect(response).not_to redirect_to(new_user_session_path)
    end

    it "responds to json" do
      get :followers, { params: { id: @user.id }, format: :json }
      expect(response.content_type).to eq "application/json"
      expect(response).not_to redirect_to(new_user_session_path)
    end
  end

  describe "GET following" do
    it "redirects following when not signed in" do
      get :following, { params: { id: @user.id } }
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe "GET following while signed in" do
    before { sign_in @user }
    it "responds to html by default" do
      get :following, { params: { id: @user.id } }
      expect(response.content_type).to eq "text/html"
      expect(response).not_to redirect_to(new_user_session_path)
    end

    it "responds to json" do
      get :following, { params: { id: @user.id }, format: :json }
      expect(response.content_type).to eq "application/json"
      expect(response).not_to redirect_to(new_user_session_path)
    end
  end

end
