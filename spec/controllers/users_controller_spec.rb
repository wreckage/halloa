require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  before do 
    @user = FactoryGirl.create(:user_with_microposts)
    @user_as_json = @user.as_json(only: [:id, :username, :gravatar_id],
                                 methods: [:followers_count,
                                           :following_count,
                                           :microposts_count])
  end
  describe "show action" do

    describe "component" do
      it "renders the Profile component" do
        get :show, { params: { id: @user.id } }
        expect(response.content_type).to eq "text/html"
        expect(assigns(:component)).to eq("Profile")
      end
    end

    describe "props" do
      it "correct when user is not signed in" do
        get :show, { params: { id: @user.id } }
        expect(assigns["props"][:user]).to eq(@user_as_json)
        expect(assigns["props"][:status]["is_following"]).to be false
        expect(assigns["props"][:status]["is_current_user"]).to be false
        expect(assigns["props"][:status]["is_signed_in"]).to be false
        expect(assigns["props"][:fetchURL]).to eq(microposts_read_path(@user))
        expect(assigns["props"][:show_profile_link]).to be false
      end

      it "correct when user is signed in and viewing own profile" do
        sign_in @user
        get :show, { params: { id: @user.id } }
        expect(assigns["props"][:status]["is_following"]).to be false
        expect(assigns["props"][:status]["is_current_user"]).to be true
        expect(assigns["props"][:status]["is_signed_in"]).to be true
      end

      it "correct when user is signed in and viewing non-following user's profile" do
        other_user = FactoryGirl.create(:user_with_microposts)
        sign_in @user
        get :show, { params: { id: other_user.id } }
        expect(assigns["props"][:status]["is_following"]).to be false
        expect(assigns["props"][:status]["is_current_user"]).to be false
        expect(assigns["props"][:status]["is_signed_in"]).to be true
      end

      it "correct when user is signed in and viewing following user's profile" do
        other_user = FactoryGirl.create(:user_with_microposts)
        sign_in @user
        @user.follow(other_user)
        get :show, { params: { id: other_user.id } }
        expect(assigns["props"][:status]["is_following"]).to be true
        expect(assigns["props"][:status]["is_current_user"]).to be false
        expect(assigns["props"][:status]["is_signed_in"]).to be true
      end
    end
  end

  describe "following action" do
    it "redirects when not signed in" do
      get :following, { params: { id: @user.id } }
      expect(response).to redirect_to(new_user_session_path)
    end

    describe "component" do
      before { sign_in @user }
      it "renders the UserIndex component" do
        get :following, { params: { id: @user.id } }
        expect(assigns(:component)).to eq("UserIndex")
      end
    end

    describe "props & package" do
      before { sign_in @user }
      it "contains user, url to following path, title (html response)" do
        get :following, { params: { id: @user.id } }
        expect(response.content_type).to eq "text/html"
        expect(assigns["props"][:user]).to eq(@user_as_json)
        expect(assigns["props"][:url]).to eq(following_user_path(@user))
        expect(assigns["props"][:title]).to eq("Following")
        expect(response).not_to redirect_to(new_user_session_path)
      end

      it "contains following users and next page info (json response)" do
        other_user1 = FactoryGirl.create(:user)
        other_user2 = FactoryGirl.create(:user)
        json1 = other_user1.as_json(only: [:id, :username, :gravatar_id])
        json2 = other_user2.as_json(only: [:id, :username, :gravatar_id])
        json3 = @user.as_json(only: [:id, :username, :gravatar_id])
        @user.follow(other_user1)
        @user.follow(other_user2)
        get :following, { params: { id: @user.id }, format: :json }
        expect(assigns["package"][:users]).to include(json1)
        expect(assigns["package"][:users]).to include(json2)
        expect(assigns["package"][:users]).not_to include(json3)
        expect(assigns["package"][:next_page]).to be nil
        expect(response.content_type).to eq "application/json"
        expect(response).not_to redirect_to(new_user_session_path)
      end
    end
  end

  describe "followers action" do
    it "redirects when not signed in" do
      get :followers, { params: { id: @user.id } }
      expect(response).to redirect_to(new_user_session_path)
    end

    describe "component" do
      before { sign_in @user }
      it "renders the UserIndex component" do
        get :followers, { params: { id: @user.id } }
        expect(assigns(:component)).to eq("UserIndex")
      end
    end

    describe "props & package" do
      before { sign_in @user }
      it "contains user, url to followers path, title (html response)" do
        get :followers, { params: { id: @user.id } }
        expect(response.content_type).to eq "text/html"
        expect(assigns["props"][:user]).to eq(@user_as_json)
        expect(assigns["props"][:url]).to eq(followers_user_path(@user))
        expect(assigns["props"][:title]).to eq("Followers")
        expect(response).not_to redirect_to(new_user_session_path)
      end

      it "contains followers and next page info (json response)" do
        other_user1 = FactoryGirl.create(:user)
        other_user2 = FactoryGirl.create(:user)
        json1 = other_user1.as_json(only: [:id, :username, :gravatar_id])
        json2 = other_user2.as_json(only: [:id, :username, :gravatar_id])
        json3 = @user.as_json(only: [:id, :username, :gravatar_id])
        other_user1.follow(@user)
        other_user2.follow(@user)
        get :followers, { params: { id: @user.id }, format: :json }
        expect(assigns["package"][:users]).to include(json1)
        expect(assigns["package"][:users]).to include(json2)
        expect(assigns["package"][:users]).not_to include(json3)
        expect(assigns["package"][:next_page]).to be nil
        expect(response.content_type).to eq "application/json"
        expect(response).not_to redirect_to(new_user_session_path)
      end
    end
  end

  describe "index action" do
    it "redirects when not signed in" do
      get :index
      expect(response).to redirect_to(new_user_session_path)
    end
    
    describe "component" do
      before { sign_in @user }
      it "renders the UserIndex component" do
        get :index
        expect(assigns(:component)).to eq("UserIndex")
      end
    end

    describe "props & package" do
      before { sign_in @user }
      it "contains correct url, title and user" do
        get :index
        expect(response.content_type).to eq "text/html"
        expect(assigns["props"][:url]).to eq(users_path)
        expect(assigns["props"][:title]).to eq("All Users")
        expect(assigns["props"][:user]).to be nil
      end

      it "contains all users paginated and the next page number (json)" do
        other_user1 = FactoryGirl.create(:user)
        other_user2 = FactoryGirl.create(:user)
        json1 = other_user1.as_json(only: [:id, :username, :gravatar_id])
        json2 = other_user2.as_json(only: [:id, :username, :gravatar_id])
        json3 = @user.as_json(only: [:id, :username, :gravatar_id])
        get :index, format: :json
        expect(response.content_type).to eq "application/json"
        expect(assigns["package"][:users]).to include(json1)
        expect(assigns["package"][:users]).to include(json2)
        expect(assigns["package"][:users]).to include(json3)
        expect(assigns["package"][:next_page]).to be nil
      end
    end
  end
end
