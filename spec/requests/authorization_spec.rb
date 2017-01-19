require 'rails_helper'

RSpec.describe "authorization", type: :request do

  before { @micropost = FactoryGirl.create(:micropost) }

  subject { page }

  describe "Micropost pages" do
    it "redirects create when not logged in" do
      expect { post microposts_path, params: {micropost: { content: "a big secret.." } }
      }.not_to change { Micropost.count }
      expect(response).to redirect_to(new_user_session_path)
    end

    it "redirects destroy when not logged in" do
      expect { delete micropost_path(@micropost) }.not_to change { Micropost.count }
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end

