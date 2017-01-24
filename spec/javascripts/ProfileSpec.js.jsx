var ReactTestUtils = React.addons.TestUtils;
// var React = React;

describe("Profile", function () {
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
  ///// Maybe use a beforeEach to create a User and Status,
  ///// then adjust them in the it functions?

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
  // since state is updated with ajax success, nothing happens
  // it("something.. click", function() {
  //   const status = new Status(false, false, true);
  //   component = profileComponent(user, status);
  //   const node = ReactTestUtils.findRenderedDOMComponentWithTag(component, "button");
  //   ReactTestUtils.Simulate.click(node);
  //   expect(node.parentNode.id).toEqual('follow_form');
  //   expect(component.state.followers_count).toBe(1);
  // });
});

describe("Profile0", function() {
  it("doesn't matter", function() {
    const user = { 
      id: 1, username: "example", gravatar_id: "x", 
      microposts_count: 0, followers_count: 0, following_count: 0
    };
    const status = { 
      is_following: false, is_current_user: true, is_signed_in: false
    };

    const renderer = ReactTestUtils.createRenderer();
    renderer.render(<Profile user={user} status={status} />);
    const result = renderer.getRenderOutput();
    
    expect(result.type).toBe('div');
    expect(result.props.children[1].props.children[1].type).toBe('h3');
    //expect(result.props).toBe(3);
      //toContain('<h3>Microposts: (0)</h3>');

    // const h3 = ReactTestUtils.scryRenderedComponentsWithType(result, 'h3');
    // expect(h3.length).toEqual(1);
  });
});

describe("Profile part 2", function () {
   beforeEach(function() {
    const user = { 
      id: 1, username: "example", gravatar_id: "x", 
      microposts_count: 0, followers_count: 0, following_count: 0
    };
    const status = { 
      is_following: false, is_current_user: false, is_signed_in: false
    };

    this.component = ReactTestUtils.renderIntoDocument(
      <Profile user={user} status={status} />
    );
    this.renderedDOM = () => ReactDOM.findDOMNode(this.component);
  });

  it("idk", function() {
    let renderedh3 = this.renderedDOM().querySelectorAll("h3");

    //expect(this.renderedDOM().children.length).toEqual(1);
    expect(renderedh3.length).toEqual(1);
    expect(renderedh3[0].textContent).toEqual("Microposts (0)");
  });
});

describe("Profile part 2 - testutils", function () {
   beforeEach(function() {
    const user = { 
      id: 1, username: "example", gravatar_id: "x", 
      microposts_count: 0, followers_count: 0, following_count: 0
    };
    const status = { 
      is_following: false, is_current_user: true, is_signed_in: false
    };

    this.component = ReactTestUtils.renderIntoDocument(
      <Profile user={user} status={status} />
    );
  });

  it("idk2", function() {
    let list = ReactTestUtils.findRenderedDOMComponentWithTag(this.component, "h3");
    // list is an htmlnode
    expect(list.textContent).toEqual("Microposts (0)");

    let node = ReactTestUtils.findRenderedDOMComponentWithClass(this.component, "micropost_form");
    expect(node.childNodes.length).toBe(1);
    //let n = ReactTestUtils.findRenderedComponentWithType(this.component, "UserInfo");
    //expect(n).toEqual(3);



    //expect(this.renderedDOM().children.length).toEqual(1);
    //expect(renderedh3.length).toEqual(1);
    //expect(renderedh3[0].textContent).toEqual("Microposts (0)");
  });
});
