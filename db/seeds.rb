40.times do |n|
  username  = Faker::Name.name
  email = "example-#{n+1}@example.com"
  password = "password"
  User.create!(username:  username,
               email: email,
               password:              password,
               password_confirmation: password)
end

# Microposts
users = User.order(:created_at).take(4)
90.times do
  content = Faker::Lorem.sentence(5)
  users.each { |user| user.microposts.create!(content: content) }
end

# Following relationships
users = User.all
user  = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }
