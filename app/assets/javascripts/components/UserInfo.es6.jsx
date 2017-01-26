class UserInfo extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      followers_count: this.props.followers_count,
      microposts_count: this.props.microposts_count
    };
  }

  componentWillReceiveProps(nextProps) {
    this.setState({
      followers_count: nextProps.followers_count,
      microposts_count: nextProps.microposts_count
    });
  }

  render() {
    return (
      <div>
        <section className="user_info"> 
          <ShowGravatar 
            username={this.props.user.username} 
            gravatar_id={this.props.user.gravatar_id} 
            size="80" 
          />
          <h1 ref="user_info_username">{this.props.user.username}</h1>
          <span ref="profile_link">
          {this.props.show_profile_link &&
              <a href={"/users/" + this.props.user.id}>View my profile</a>
          }
          </span>
          <span ref="user_info_microposts_count">
            Microposts ({this.state.microposts_count})
          </span>
        </section>
        <section className="stats">
          <UserStats 
            user={this.props.user} 
            followers_count={this.state.followers_count} 
          />
        </section>
      </div>
    );
  }
}

UserInfo.propTypes = {
  user:              React.PropTypes.object,
  followers_count:   React.PropTypes.number,
  microposts_count:  React.PropTypes.number,
  show_profile_link: React.PropTypes.bool
}
