class Profile extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      page: 1,
      next_page: 0,
      microposts: [],
      errors: {}
    };
    this.showMicroposts = this.showMicroposts.bind(this);
    this.fetchMicroposts = this.fetchMicroposts.bind(this);
  }

  componentDidMount() {
    const url = (
      '/users/' + this.props.user.id + 
      '/microposts?page=' + this.state.page)
    $.getJSON(url, (data) => { 
      this.setState({ microposts: data.microposts, next_page: data.next_page })
    });
  }

  showMicroposts() {
    return this.state.microposts.map((micropost) =>
      <li key={micropost.id} id={"micropost-" + micropost.id}>
        {this.gravatar_img()}
        <span className="user">
          <a href={"/users/" + micropost.user_id}>
            {micropost.user.username}
          </a>
        </span>
        <span className="content">{micropost.content}</span>
        <span className="timestamp">Post: {micropost.created_at}</span>
      </li>
    );
  }

  fetchMicroposts(e, direction) {
    e && e.preventDefault();
    let page = this.state.next_page;
    if (!direction)
      page = 1;
    else if (direction == "prev")
      page = this.state.page - 1;

    const url = (
      '/users/' + this.props.user.id + 
      '/microposts?page=' + page)
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

  handlePagination() {
    return (
      <ul className="pagination">
        {this.state.page > 1 &&
          <li className="previous previous_page ">
            <a href="#" onClick={(e) => this.fetchMicroposts(e, "prev")}>&#8592;Prev</a>
          </li>
        }
        {this.state.next_page > 0 &&
          <li className="next next_page ">
            <a href="#" onClick={(e) => this.fetchMicroposts(e, "next")}>Next &#8594;</a>
          </li>
        }
      </ul>
      );
  }

  gravatar_img() {
    return (
      <img className="gravatar" alt={this.props.user.username}
      src={"https://secure.gravatar.com/avatar/" + this.props.gravatar_id + "?s=50"} />
    )
  }

  render() {
    return (
      <div className="row">
        <aside className="col-md-4">
          <section className="user_info"> 
            {this.gravatar_img()}
            <h1>{this.props.user.username}</h1>
            <span>
                Hello from inside Profile component
            </span>
          </section>
          <section className="micropost_form">
            <MicropostForm refreshFeed={this.fetchMicroposts} />
          </section>
        </aside>
          <div className="col-md-8">
            <h3>Microposts ({this.props.microposts_total})</h3>
            {this.handlePagination()}
            <ol className="microposts">
              {this.showMicroposts()}
            </ol>
            {this.handlePagination()}
          </div>
      </div>
    );
  }
}
