class Profile extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      page: 1,
      next_page: 0,
      microposts: [],
      microposts_count: this.props.user.microposts_count,
      followers_count: this.props.user.followers_count,
      is_following: this.props.status.is_following,
      errors: {}
    };
    this.fetchMicroposts = this.fetchMicroposts.bind(this);
    this.updateMicropostTotal = this.updateMicropostTotal.bind(this);
    this.updateFollowers = this.updateFollowers.bind(this);
  }

  componentDidMount() {
    const url = (
      '/users/' + this.props.user.id + 
      '/microposts?page=' + this.state.page)
    $.getJSON(url, (data) => { 
      this.setState({ microposts: data.microposts, next_page: data.next_page })
    });
  }

  fetchMicroposts(e, direction) {
    e && e.preventDefault(); // might not come from click (e.g. in MicropostForm)
    let page = this.state.next_page;
    if (!direction)
      page = 1;
    else if (direction === "prev")
      page = this.state.page - 1;

    const url = '/users/' + this.props.user.id + '/microposts?page=' + page
    $.ajax({
      method: 'GET',
      dataType: "json",
      url: url,
      complete: () => $("html, body").animate({ scrollTop: 0 }, "slow"),
      success: (data) => {
        this.setState({
          microposts: data.microposts, 
          next_page: data.next_page,
          page: page});
      }
    });
  }

  updateMicropostTotal(num) {
    this.setState({ microposts_count: this.state.microposts_count + num });
  }

  updateFollowers(num) {
    this.setState({ 
      followers_count: this.state.followers_count + num,
      is_following: !this.state.is_following
    });
  }

  render() {
    return (
      <div className="row">
        <aside className="col-md-4">
          <UserInfo
            user={this.props.user}
            followers_count={this.state.followers_count} 
            microposts_count={this.state.microposts_count}
            show_profile_link={false}
          />
          <section ref="micropost_form" className="micropost_form">
            {this.props.status.is_current_user &&
              <MicropostForm 
                refreshFeed={this.fetchMicroposts} 
                incTotal={this.updateMicropostTotal} 
              />
            }
          </section>
        </aside>
        <div className="col-md-8">
          <div ref="follow_button" className="follow_button">
          {(this.props.status.is_signed_in && !this.props.status.is_current_user) &&
              <FollowButton 
                followed_id={this.props.user.id}
                is_following={this.state.is_following}
                updateFollowers={this.updateFollowers}
              />
          }
          </div>
          <h3>Microposts ({this.state.microposts_count})</h3>
          <HandlePagination 
            page={this.state.page}
            next_page={this.state.next_page}
            fetchIt={this.fetchMicroposts}
          />
          <ShowMicroposts 
            microposts={this.state.microposts}
            refreshFeed={this.fetchMicroposts} 
            decTotal={this.updateMicropostTotal} 
            user_id={this.props.user.id}
            is_current_user={this.props.status.is_current_user}
          />
          <HandlePagination 
            page={this.state.page}
            next_page={this.state.next_page}
            fetchIt={this.fetchMicroposts}
          />
        </div>
      </div>
    );
  }
}

Profile.propTypes = {
  user:   React.PropTypes.object,
  status: React.PropTypes.object
}
