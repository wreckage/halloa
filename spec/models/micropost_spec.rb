require 'rails_helper'

RSpec.describe Micropost, type: :model do
  before { @micropost = FactoryGirl.create(:micropost) }

  subject { @micropost }

  describe "when it is created with valid information" do
    it { is_expected.to be_valid }
  end

  describe "order returned from the database" do
    it "is most recent first" do
      micropost_recent = FactoryGirl.create(:micropost, created_at: 2.days.ago)
      micropost_oldest = FactoryGirl.create(:micropost, created_at: 100.days.ago)
      expect(Micropost.first).to eq(micropost_recent)
      expect(Micropost.last).to eq(micropost_oldest)
    end
  end

end
