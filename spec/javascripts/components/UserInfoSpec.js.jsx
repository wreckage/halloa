describe("UserInfo Component", function () {
  const user = { 
    id: 1, username: "example", gravatar_id: "x", 
    microposts_count: 0, followers_count: 0, following_count: 0
  };

  function UserInfoComponent(user, followers_count, microposts_count, show_profile_link) {
    return ReactTestUtils.renderIntoDocument(
      <UserInfo 
        user={user} 
        followers_count={followers_count} 
        microposts_count={microposts_count} 
        show_profile_link={show_profile_link} 
      />
    );
  }

  it("sets the correct initial state", function() {
    component = UserInfoComponent(user, 11, 20, false);
    expect(component.state.followers_count).toBe(11);
    expect(component.state.microposts_count).toBe(20);
  });

  // tests componentWillReceiveProps
  // see: http://stackoverflow.com/a/30616091
  it("updates state if props change", function() {
    const node = document.createElement('div');
    let component = ReactDOM.render(
      <UserInfo 
        user={user} 
        followers_count={1}
        microposts_count={1}
        show_profile_link={false}
      />, node
    );
    expect(component.state.followers_count).toBe(1);
    expect(component.state.microposts_count).toBe(1);
    ReactDOM.render(
      <UserInfo 
        user={user} 
        followers_count={2}
        microposts_count={2}
        show_profile_link={false}
      />, node
    );
    expect(component.state.followers_count).toBe(2);
    expect(component.state.microposts_count).toBe(2);
  });

  it("displays the user's username", function() {
    component = UserInfoComponent(user, 1, 1, true);
    const node = ReactDOM.findDOMNode(component.refs.user_info_username);
    expect(node.textContent).toBe("example");
  });

  it("displays the correct number of microposts", function() {
    component = UserInfoComponent(user, 1, 12, true);
    const node = ReactDOM.findDOMNode(component.refs.user_info_microposts_count);
    expect(node.textContent).toBe("Microposts (12)");
  });

  it("displays profile link if show_profile_link is true", function() {
    component = UserInfoComponent(user, 1, 1, true);
    const node = ReactDOM.findDOMNode(component.refs.profile_link);
    expect(node.childNodes.length).toBe(1);
  });

  it("does not display profile link if show_profile_link is false", function() {
    component = UserInfoComponent(user, 1, 1, false);
    const node = ReactDOM.findDOMNode(component.refs.profile_link);
    expect(node.childNodes.length).toBe(0);
  });
})
