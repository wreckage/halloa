require 'rails_helper'

RSpec.describe MicropostsController, type: :controller do
  before do
    @user = FactoryGirl.create(:user_with_microposts, microposts_count: 5)
    @user_as_json = @user.as_json(only: [:id, :username, :gravatar_id],
                                 methods: [:followers_count,
                                           :following_count,
                                           :microposts_count])
  end

  describe "feed action" do
    it "redirects when format is not json" do
      sign_in @user
      get :feed, { params: { id: @user.id } }
      expect(response).to redirect_to(root_url)
      get :feed, { params: { id: @user.id }, format: :json }
      expect(response.content_type).to eq "application/json"
    end

    it "responds with a 401 status if not signed in" do
      get :feed, { params: { id: @user.id }, format: :json }
      expect(response.status).to eq(401)
    end

    describe "json package" do
      before { sign_in @user }
      it "contains only own posts if not following anybody" do
        FactoryGirl.create(:user_with_microposts)
        get :feed, { params: { id: @user.id }, format: :json }
        expect(assigns["package"][:microposts].count).to be(5)
      end

      it "contains following user's microposts" do
        sign_in @user
        other_user1 = FactoryGirl.create(:user_with_microposts, microposts_count: 10)
        other_user2 = FactoryGirl.create(:user_with_microposts, microposts_count: 10)
        @user.follow(other_user1)
        @user.follow(other_user2)
        get :feed, { params: { id: @user.id }, format: :json }
        expect(assigns["package"][:next_page]).to be nil
        expect(assigns["package"][:microposts].count).to be(25)
        # check that all microposts' contents are in the feed
        contents = []
        other_user1.microposts.each { |mpost| contents << mpost.content }
        other_user2.microposts.each { |mpost| contents << mpost.content }
        @user.microposts.each { |mpost| contents << mpost.content }
        assigns["package"][:microposts].each do |mpost|
          expect(contents).to include(mpost["content"])
        end
      end

      it "contains correct next_page" do
        other_user1 = FactoryGirl.create(:user_with_microposts, microposts_count: 40)
        @user.follow(other_user1)
        get :feed, { params: { id: @user.id }, format: :json }
        expect(assigns["package"][:microposts].count).to be(30)
        expect(assigns["package"][:next_page]).to be(2)
      end
    end
  end

  describe "read action" do
    it "redirects when format is not json" do
      get :read, { params: { id: @user.id } }
      expect(response).to redirect_to(root_url)
      get :read, { params: { id: @user.id }, format: :json }
      expect(response.content_type).to eq "application/json"
    end
    describe "json package" do
      it "contains a user's own microposts" do
        other_user = FactoryGirl.create(:user_with_microposts, microposts_count: 2)
        @user.follow(other_user)
        get :read, { params: { id: @user.id }, format: :json }
        expect(assigns["package"][:next_page]).to be nil
        expect(assigns["package"][:microposts].count).to be(5)
        user_mpost_contents = []
        other_user_mpost_contents = []
        @user.microposts.each { |mpost| user_mpost_contents << mpost.content }
        other_user.microposts.each { |mpost| other_user_mpost_contents << mpost.content }
        assigns["package"][:microposts].each do |mpost|
          expect(user_mpost_contents).to include(mpost["content"])
          expect(other_user_mpost_contents).not_to include(mpost["content"])
        end
      end

      it "contains correct next_page" do
        other_user = FactoryGirl.create(:user_with_microposts, microposts_count: 40)
        get :read, { params: { id: other_user.id }, format: :json }
        expect(assigns["package"][:microposts].count).to be(30)
        expect(assigns["package"][:next_page]).to be(2)
      end
    end
  end
end
