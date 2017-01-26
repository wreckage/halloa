require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  before do 
    @user = FactoryGirl.create(:user_with_microposts)
    @user_as_json = @user.as_json(only: [:id, :username, :gravatar_id],
                                 methods: [:followers_count,
                                           :following_count,
                                           :microposts_count])
  end
  describe "index action" do
    describe "not signed in" do
      it "renders the Home component" do
        get :index
        expect(assigns(:component)).to eq("Home")
      end
    end
    describe "signed in" do
      before { sign_in @user }
      it "renders the Profile component" do
        get :index
        expect(assigns(:component)).to eq("Profile")
      end
      describe "props" do
        it "contains user, status, fetchURL and show_profile_link" do
          get :index
          expect(assigns["props"][:user]).to eq(@user_as_json)
          expect(assigns["props"][:status]["is_following"]).to be false
          expect(assigns["props"][:status]["is_current_user"]).to be true
          expect(assigns["props"][:status]["is_signed_in"]).to be true
          expect(assigns["props"][:fetchURL]).to eq(user_feed_path(@user))
          expect(assigns["props"][:show_profile_link]).to be true
        end
      end
    end
  end
end
