class UserStats extends React.Component {
  constructor(props) {         
    super(props);              
    this.state = {
      followers_count: this.props.followers_count,
      errors: {}
    };
  }

  componentWillReceiveProps(nextProps) {
    this.setState({
      followers_count: nextProps.followers_count
    });
  }

  render() {
    return (
      <div className="stats">
        <a href={"/users/" + this.props.user.id + "/following"}>
          <strong id="following" className="stat">
            {this.props.user.following_count}
          </strong>
          following
        </a>
        <a href={"/users/" + this.props.user.id + "/followers"}>
          <strong id="followers" className="stat">
            {this.state.followers_count}
          </strong>
          followers
        </a>
      </div>
    );
  }
}
