require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let(:follower) { FactoryGirl.create(:user) }
  let(:followed) { FactoryGirl.create(:user) }
  let(:relationship) { follower.active_relationships.build(followed_id: followed.id) }

  subject { relationship }

  it { is_expected.to be_valid }

  describe "follower methods" do
      it { is_expected.to respond_to(:follower) }
      it { is_expected.to respond_to(:followed) }
      it { expect(relationship.followed).to eq(followed) }
      it { expect(relationship.follower).to eq(follower) }
  end
      
  describe "when follower_id is nil" do
      before { relationship.follower_id = nil }
      it { is_expected.not_to be_valid } 
  end
    
  describe "when followed_id is nil" do
      before { relationship.followed_id = nil }
      it { is_expected.not_to be_valid } 
  end
end
