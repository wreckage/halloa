Feature: Logging in
  As a visitor
  I want to log in to my account

  Scenario: Unsuccessful login
    Given I visit the home page    
    And  I click the sign in link    
    When I submit invalid login information
    Then I should see an error message

  Scenario: Successful login   
    Given I visit the login page
      And I have an account    
    When I submit valid login information
    Then I should see my profile page
      And I should see a log out link
