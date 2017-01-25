var ReactTestUtils = React.addons.TestUtils;
// var React = React;

describe("Profile Component", function () {
  const user = { 
    id: 1, username: "example", gravatar_id: "x", 
    microposts_count: 0, followers_count: 0, following_count: 0
  };
  function Status(is_following, is_current_user, is_signed_in) {
    this.is_following    = is_following;
    this.is_current_user = is_current_user;
    this.is_signed_in    = is_signed_in;
  }
  function profileComponent(user, status) {
    return ReactTestUtils.renderIntoDocument(
      <Profile user={user} status={status} />
    );
  }
  it("displays micropost form if user is current user", function() {
    const status = new Status(false, true, false);
    component = profileComponent(user, status);
    const node = ReactDOM.findDOMNode(component.refs.micropost_form);
    expect(node.childNodes.length).toBe(1);
  });

  it("doesn't display micropost form if user is not current user", function() {
    const status = new Status(false, false, false);
    component = profileComponent(user, status);
    const node = ReactDOM.findDOMNode(component.refs.micropost_form);
    expect(node.childNodes.length).toBe(0);
  });

  it("displays FollowButton if user is signed in and is not the current user", function() {
    const status = new Status(false, false, true);
    component = profileComponent(user, status);
    const node = ReactDOM.findDOMNode(component.refs.follow_button);
    expect(node.childNodes.length).toBe(1);
  });

  it("doesn't display FollowButton if user is not signed in", function() {
    const status = new Status(false, false, false);
    component = profileComponent(user, status);
    const node = ReactDOM.findDOMNode(component.refs.follow_button);
    expect(node.childNodes.length).toBe(0);
  });

  it("doesn't display FollowButton if user is signed in and is the current user", function() {
    const status = new Status(false, true, true);
    component = profileComponent(user, status);
    const node = ReactDOM.findDOMNode(component.refs.follow_button);
    expect(node.childNodes.length).toBe(0);
  });

  it("updates followers_count and is_following via updateFollowers function", function() {
    const status = new Status(false, false, true);
    component = profileComponent(user, status);
    expect(component.state.followers_count).toBe(0);
    // simulate a follow
    component.updateFollowers(1);
    expect(component.state.followers_count).toBe(1);
    expect(component.state.is_following).toBe(true);
    // simulate an unfollow
    component.updateFollowers(-1);
    expect(component.state.followers_count).toBe(0);
    expect(component.state.is_following).toBe(false);
  });

  it("updates micropost total via updateMicropostTotal function", function() {
    const status = new Status(false, false, true);
    component = profileComponent(user, status);
    expect(component.state.microposts_count).toBe(0);
    // creating a micropost
    component.updateMicropostTotal(1);
    expect(component.state.microposts_count).toBe(1);
    // deleting a micropost
    component.updateMicropostTotal(-1);
    expect(component.state.microposts_count).toBe(0);
  });
});
