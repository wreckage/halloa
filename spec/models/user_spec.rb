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

  describe "when saved to the database" do
    it "is saved with gravatar_id" do
      id = Digest::MD5::hexdigest(@user.email.downcase)
      expect(@user.gravatar_id).to eq(id)
    end
  end

  describe "when email changes" do
    it "has new gravtar_id" do
      email = "drpepper@example.com"
      @user.email = email
      @user.save
      @user.reload
      expect(@user.gravatar_id).to eq(Digest::MD5::hexdigest(email))
    end
  end

  describe "when email change is invalid" do
    it "does not save new gravtar_id" do
      email = @user.email
      invalid_email = ""
      @user.email = invalid_email
      @user.save
      @user.reload
      expect(@user.gravatar_id).not_to eq(Digest::MD5::hexdigest(invalid_email))
      expect(@user.gravatar_id).to eq(Digest::MD5::hexdigest(email))
    end
  end

  it "follows and unfollowers another user" do
    user = FactoryGirl.create(:user)
    expect(@user.following?(user)).to be false
    @user.follow(user)
    expect(@user.following?(user)).to be true
    expect(user.followers.include?(@user)).to be true
    @user.unfollow(user)
    expect(@user.following?(user)).to be false
  end
end
