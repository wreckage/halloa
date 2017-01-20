class Profile extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      page: 1,
      next_page: 0,
      microposts: [],
      micropost_total: this.props.micropost_total,
      errors: {}
    };
    this.fetchMicroposts = this.fetchMicroposts.bind(this);
    this.updateMicropostTotal = this.updateMicropostTotal.bind(this);
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

  updateMicropostTotal(opt) {
    typeof opt === "number" && this.setState({ micropost_total: this.state.micropost_total + opt });
  }

  render() {
    return (
      <div className="row">
        <aside className="col-md-4">
          <section className="user_info"> 
            <ShowGravatar 
              username={this.props.user.username} 
              gravatar_id={this.props.user.gravatar_id} 
              size="50" 
            />
            <h1>{this.props.user.username}</h1>
            <span>
                Hello from inside Profile component
            </span>
          </section>
          <section className="micropost_form">
            {this.props.is_current_user &&
              <MicropostForm 
                refreshFeed={this.fetchMicroposts} 
                incTotal={this.updateMicropostTotal} 
              />
            }
          </section>
        </aside>
          <div className="col-md-8">
            <h3>Microposts ({this.state.micropost_total})</h3>
            <HandlePagination 
              page={this.state.page}
              next_page={this.state.next_page}
              fetchIt={this.fetchMicroposts}
            />
            <ShowMicroposts 
              microposts={this.state.microposts}
              refreshFeed={this.fetchMicroposts} 
              decTotal={this.updateMicropostTotal} 
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
