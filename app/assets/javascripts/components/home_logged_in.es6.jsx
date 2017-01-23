class HomeLoggedIn extends React.Component {
  constructor(props) {         
    super(props);              
    this.state = {
      page: 1,
      next_page: 0,
      microposts: [],
      microposts_count: this.props.user.microposts_count,
      errors: {}
    };
    this.fetchFeed = this.fetchFeed.bind(this);
    this.updateMicropostTotal = this.updateMicropostTotal.bind(this);
  }

  componentDidMount() {
    const url = (
      '/users/' + this.props.user.id + 
      '/feed?page=' + this.state.page)
    $.getJSON(url, (data) => { 
      this.setState({ microposts: data.microposts, next_page: data.next_page });
    });
  }

  fetchFeed(e, direction) {
    e && e.preventDefault(); // might not come from click (e.g. in MicropostForm)
    let page = this.state.next_page;
    if (!direction)
      page = 1;
    else if (direction === "prev")
      page = this.state.page - 1;

    const url = '/users/' + this.props.user.id + '/feed?page=' + page
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

  updateMicropostTotal(opt) {
    typeof opt === "number" && this.setState({ microposts_count: this.state.microposts_count + opt });
  }

  render() {
    return (
      <div className="row">    
        <aside className="col-md-4">    
          <UserInfo
            user={this.props.user}
            followers_count={this.props.user.followers_count} 
            microposts_count={this.state.microposts_count}
            show_profile_link={true}
          />
          <section className="micropost_form">
            <MicropostForm 
              refreshFeed={this.fetchFeed} 
              incTotal={this.updateMicropostTotal} 
            />
          </section>
        </aside>
          <div className="col-md-8">
            <h3>Micropost Feed</h3>
            <HandlePagination 
              page={this.state.page}
              next_page={this.state.next_page}
              fetchIt={this.fetchFeed}
            />
            <ShowMicroposts 
              microposts={this.state.microposts}
              refreshFeed={this.fetchFeed} 
              decTotal={this.updateMicropostTotal} 
              user_id={this.props.user.id}
              is_current_user={true}
            />
            <HandlePagination 
              page={this.state.page}
              next_page={this.state.next_page}
              fetchIt={this.fetchFeed}
            />
          </div>
      </div>
    );  
  }     
}

HomeLoggedIn.propTypes = {
  user: React.PropTypes.object,
  is_current_user: React.PropTypes.bool
}
