require 'rails_helper'

RSpec.describe "Micropost Resource", type: :request do

  before do
    @micropost = FactoryGirl.create(:micropost)
    @user = FactoryGirl.create(:user_with_microposts)
    sign_in @user
  end

  describe "Unsuccessful interaction" do
    it "redirects create when not logged in" do
      sign_out @user
      expect { post microposts_path, params: {micropost: { content: "a big secret.." } }
      }.not_to change { Micropost.count }
      expect(response).to redirect_to(new_user_session_path)
    end

    it "redirects destroy when not logged in" do
      sign_out @user
      expect { delete micropost_path(@micropost) 
      }.not_to change { Micropost.count }
      expect(response).to redirect_to(new_user_session_path)
    end

    it "should redirect destroy for wrong micropost" do
      expect { delete micropost_path(@micropost)
      }.not_to change { Micropost.count }
    end
  end

  describe "Successful interaction" do
    it "destroys microposts" do
      expect { delete micropost_path(@user.microposts.first)
      }.to change { Micropost.count }.by(-1)
    end

    it "creates microposts" do
      expect { post microposts_path, params: {micropost: { content: "a big secret.." } }
      }.to change { Micropost.count }.by(1)
    end

    it "responds with a user's microposts" do
      get microposts_read_path(@user), as: :json
      @user.microposts.each do |mpost|
        expect(JSON.parse(response.body).to_s).to include(mpost.content)
      end
    end
  end
end

