class UserIndex extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      users: [],
      page: 1,
      next_page: 0
    };
    this.showUsers = this.showUsers.bind(this);
  }

  componentDidMount() {
    $.getJSON(this.props.url, (data) => {
      this.setState({ users: data.users, next_page: data.next_page })
    });
  }

  fetchUsers(e, direction) {
    e && e.preventDefault();
    let page = this.state.next_page;
    if (!direction)
      page = 1;
    else if (direction == "prev")
      page = this.state.page - 1;

    const url = this.props.url + '?page=' + page
    $.ajax({
      method: 'GET',
      dataType: "json",
      url: url,
      complete: () => $("html, body").animate({ scrollTop: 0 }, "slow"),
      success: (data) => {
        this.setState({
          users: data.users,
          next_page: data.next_page,
          page: page});
      }
    });
  }

  showUsers() {
    return this.state.users.map((user) =>
      <li key={user.id} id={"user-" + user.id}>
        <ShowGravatar 
          username={user.username} 
          gravatar_id={user.gravatar_id} 
          size="50" 
        />
        <a href={'/users/' + user.id}>
          {user.username}
        </a>
      </li>
    );
  }

  render() {
    return (
      <div>
        <h1>{this.props.title}</h1>
        <ul className="users">
          {this.showUsers()}
        </ul>
        <HandlePagination 
          page={this.state.page}
          next_page={this.state.next_page}
          fetchIt={this.fetchUsers}
        />
      </div>
    );
  }
}
