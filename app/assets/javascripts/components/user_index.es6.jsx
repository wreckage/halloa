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
    $.getJSON('/users', (data) => {
      this.setState({ users: data.users, next_page: data.next_page })
    });
  }

  handlePagination() {
    return (
      <ul className="pagination">
        {this.state.page > 1 &&
          <li className="previous previous_page ">
            <a href="#" onClick={(e) => this.fetchUsers(e, "prev")}>&#8592;Prev</a>
          </li>
        }
        {this.state.next_page > 0 &&
          <li className="next next_page ">
            <a href="#" onClick={(e) => this.fetchUsers(e, "next")}>Next &#8594;</a>
          </li>
        }
      </ul>
      );
  }

  fetchUsers(e, direction) {
    e && e.preventDefault();
    let page = this.state.next_page;
    if (!direction)
      page = 1;
    else if (direction == "prev")
      page = this.state.page - 1;

    const url = '/users?page=' + page
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

  gravatar_img(username, grav_id) {
    return (
      <img className="gravatar" alt={username}
      src={"https://secure.gravatar.com/avatar/" + grav_id + "?s=50"} />
    )
  }

  showUsers() {
    return this.state.users.map((user) =>
      <li key={user.id} id={"user-" + user.id}>
        {this.gravatar_img(user.username, user.gravatar_id)}
        <a href={'/users/' + user.id}>
          {user.username}
        </a>
      </li>
    );
  }

  render() {
    return (
      <div>
        <h1>All Users</h1>
        <ul className="users">
          {this.showUsers()}
        </ul>
        {this.handlePagination()}
      </div>
    );
  }
}
