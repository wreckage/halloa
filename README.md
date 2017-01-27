# Halloa!
## A twitter style example app created with React.js, Ruby on Rails 5, and Devise

## Getting started

To get started with the app, clone the repo and then install the needed gems:

```
$ bundle install --without production
```

Next, migrate the database:

```
$ rails db:migrate
```

(Optional) Seed the database:

```
$ rails db:seed
```

Run the dev server:

```
$ rails server
```
## About
 
This app was created to demonstrate an approach to combining [React] (https://facebook.github.io/react/) 
& [Rails] (http://rubyonrails.org/). The focus of the app
is on React, and so [Devise] (https://github.com/plataformatec/devise) was brought in to handle users. 
This app can be thought of as a re-creation of Michael Hartl's 
[Ruby on Rails Tutorial] (https://www.railstutorial.org/book/) using React and Devise.

Instead of adding react components into rails views via the react helper 
(which looks like `<%= react_component('HelloMessage', name: 'John') %>`), the server
renders react components and props from the controller. This means that everything you see in the site (with
the exception of the header) is a react component rendered on top of the base application.html.erb view.

Unlike in Hartl's tutorial, this app interacts with a micropost resource. As an example, when a user
visits their profile, the `Profile` react component is mounted, which triggers its
`componentsDidMount()` function, which sends out an ajax request for a user's microposts. The server
then sends those microposts back to be rendered by the `Profile` component (which it does via
the `ShowMicroposts` child component). Similarly, the `UserIndex` component makes use of a users resource.

There are a total of 11 components found in `app/assets/javascripts/components`. Two of them are
parent components (`Profile` and `UserIndex`), one of them is a stand-alone component (`Home`), and
the rest are children that help the two parent components.


## Tour
### (React focus)

When you first visit the site, you are greeted by the `Home` component. This component is a simple
Javascript function. Clicking on "Sign up" takes you to the user
creation form served up by Devise. After successfully creating an account, we arrive back at
the home page, but it looks different this time. Because we are signed in, the home page is 
now rendered by the `Profile` Class component. This component uses state and props to put
itself together.

On the left we see our username and some other information, all of it brought to us by the
UserInfo child component. This component uses the UserGravatar component to render a [gravatar] (gravatar.com),
and the UserStats component to show our followers / following info. Below all that we see the micropost
form, which is yet another react component (called `MicropostForm`).

Writing a post and clicking the "Post" button has our post show up in our feed without a page refresh.
When the "Post" button is clicked, it is handled by an `onSubmit` function within the `MicropostForm` component, 
which sends the value of the form to the server via ajax. On successful submission the micropost count is incremented 
and the micropost feed is refreshed asynchronously. If we now click the 'delete' link on our new post, the post
will be deleted asynchronously.

Clicking the "Users" link in the header takes us to a list of all the users on the site. This page is
rendered by the `UserIndex` component. At the bottom of the page we see a simple pagination system
brought to us by the `HandlePagination` component. This component works with the rails backend to
provide a very simple pagination mechanism (*very* simple). It works asynchronously to load up
the next or previous page of users.

Clicking on a user's username takes us to their profile page, which is rendered by the `Profile` component.
Under the user's stats we see a follow button, and clicking it sends out an ajax request that lets us
follow the user and increments the user's 'followers' stat. If we now navigate back home, we see that
the other user's microposts are included in our feed and our 'following' number has been incremented. 
We can click on the 'following' link in our stats section to visit the 'Following' page, 
which is rendered by the `UserIndex` component.


## Notes
- Pressing the back button was causing some components to misbehave, so I had to disable turbolinks caching
  in the header of the application.html.erb view.
- Since the app uses react components, instance variables are unavailable. Everything the component needs
  must be sent out by the controller (which is packaged in an @props instance variable to aid in testing)
  or received via an ajax call (which is how, for example, the micropost feed is obtained).


## Testing
Tests are implemented in two ways: React tests are handled with [jasmine] (https://jasmine.github.io/), 
Rails tests by [Rspec] (https://github.com/rspec/rspec-rails).

To run the rspec test suite:

```
$ rspec
```

To run the jasmine test suite:

```
$ rails jasmine
```

## To do
- More tests
