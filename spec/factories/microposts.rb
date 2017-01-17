FactoryGirl.define do
  factory :micropost do
    user
    content { Faker::Lorem.sentence(5) }
    created_at 42.days.ago
  end
end
