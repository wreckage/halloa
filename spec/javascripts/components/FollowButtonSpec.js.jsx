describe("FollowButton Component", function() {
  function FollowButtonComponent(followed_id, is_following, updateFollowers) {
    return ReactTestUtils.renderIntoDocument(
      <FollowButton 
        followed_id={followed_id} 
        is_following={is_following} 
        updateFollowers={updateFollowers}
      />
    );
  }

  it("sets the correct state when is_following is true", function() {
    component = FollowButtonComponent(1, true, null);
    expect(component.state.text).toBe("Unfollow");
    expect(component.state.verb).toBe("DELETE");
    expect(component.state.num).toBe(-1);
  });

  it("sets the correct state when is_following is false", function() {
    component = FollowButtonComponent(1, false, null);
    expect(component.state.text).toBe("Follow");
    expect(component.state.verb).toBe("POST");
    expect(component.state.num).toBe(1);
  });

  // tests componentWillReceiveProps
  // see: http://stackoverflow.com/a/30616091
  it("updates state if props change", function() {
    const node = document.createElement('div');
    let component = ReactDOM.render(
      <FollowButton 
        followed_id={1}
        is_following={false}
        updateFollowers={null}
      />, node
    );
    expect(component.state.text).toBe("Follow");
    expect(component.state.verb).toBe("POST");
    expect(component.state.num).toBe(1);
    ReactDOM.render(
      <FollowButton 
        followed_id={1}
        is_following={true}
        updateFollowers={null}
      />, node
    );
    expect(component.state.text).toBe("Unfollow");
    expect(component.state.verb).toBe("DELETE");
    expect(component.state.num).toBe(-1);
  });
});
