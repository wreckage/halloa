require 'faker'

FactoryGirl.define do
  factory :user do
    username { Faker::Name.first_name }
    email { Faker::Internet.email }
    password "foobar"
    password_confirmation "foobar"
    transient do
        microposts_count 5
    end

    factory :user_with_microposts do
        after(:create) do |user, evaluator|
            create_list(:micropost, evaluator.microposts_count, user: user)
        end
    end
  end
end

