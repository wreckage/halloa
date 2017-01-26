class FollowButton extends React.Component {
  constructor(props) {         
    super(props);              
    this.state = {
      text: this.props.is_following ? "Unfollow" : "Follow",
      verb: this.props.is_following ? "DELETE" : "POST",
      num:  this.props.is_following ? -1 : 1
    };
    this.sendRequest = this.sendRequest.bind(this);
  }

  // update state when props change
  componentWillReceiveProps(nextProps) {
    this.setState({
      text: nextProps.is_following ? "Unfollow" : "Follow",
      verb: nextProps.is_following ? "DELETE" : "POST",
      num:  nextProps.is_following ? -1 : 1
    });
  }

  sendRequest(e) {
    e.preventDefault();
    $.ajax({
      method: this.state.verb,
      data: { followed_id: this.props.followed_id },
      url: '/relationships',
      success: (res) => {
        this.props.updateFollowers(this.state.num);    // update total followers count
      },
      error: (res) => {}
    });
  }

  render() {
    return (
      <div id="follow_form">
        <button onClick={this.sendRequest}>{this.state.text}</button>
      </div>
    );
  }
}

FollowButton.propTypes = {
  followed_id: React.PropTypes.number,
  is_following: React.PropTypes.bool,
  updateFollowers: React.PropTypes.func
}
