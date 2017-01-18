User.create!(username:  "reu",
             email: "reubenurbina@gmail.com",
             password:              "foobar",
             password_confirmation: "foobar")

22.times do |n|
  username  = Faker::Name.name
  email = "example-#{n+1}@example.com"
  password = "password"
  User.create!(username:  username,
               email: email,
               password:              password,
               password_confirmation: password)
end

users = User.order(:created_at).take(4)
90.times do
  content = Faker::Lorem.sentence(5)
  users.each { |user| user.microposts.create!(content: content) }
end
