Given(/^I visit the home page$/) do
  visit root_path
end

Then(/^I click the sign in link$/) do
    click_link "Sign in"
end

When(/^I submit invalid login information$/) do
    click_button "Log in"
end

Then(/^I should see an error message$/) do
    expect(page).to have_selector('div.alert.alert-alert')
end

Given(/^I visit the login page$/) do
  visit new_user_session_path
end

Given(/I have an account$/) do
  @user = User.create(name: "example", email: "example@example.com",
                      password: "foobar", password_confirmation: "foobar")
end

When(/^I submit valid login information$/) do
  fill_in "Email",    with: @user.email
  fill_in "Password", with: @user.password
  click_button "Log in"
end

Then(/^I should see my profile page$/) do
    expect(page).to have_selector('h1', text: @user.name)
end

Then(/^I should see a log out link$/) do
    expect(page).to have_link(text: /Log out/i, href: destroy_user_session_path)
end

And(/^I should see a success message$/) do
    expect(page).to have_selector('div.alert.alert-success')
end

