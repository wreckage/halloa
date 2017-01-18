require 'rails_helper'

RSpec.describe User, type: :model do

  before { @user = FactoryGirl.create(:user) }

  subject { @user }

  describe "when it is created with valid information" do
    it { is_expected.to be_valid }
  end

  describe "when username is not present" do
    before { @user.username = " " }
    it { is_expected.not_to be_valid }
  end

  describe "when username is too long" do
    before { @user.username = 'a' * 51 }
    it { is_expected.not_to be_valid }
  end

  describe "if username is already taken" do
    it "should not be valid" do
      FactoryGirl.create(:user, username: "hank")
      user2 = FactoryGirl.build(:user, username: "hAnk")
      expect(user2).not_to be_valid
    end
  end

  describe "when destroyed" do
    it "destroys associated microposts" do
      user = FactoryGirl.create(:user_with_microposts, microposts_count: 1)
      expect { user.destroy }.to change { Micropost.count }.by(-1)
    end
  end


end
