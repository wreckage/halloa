class ShowMicroposts extends React.Component {
  constructor(props) { super(props); }

  deleteMicropost(e, id) {
    e.preventDefault();
    $.ajax({
      method: 'DELETE',
      url: '/microposts/' + id,
      success: (res) => {
        this.props.refreshFeed(); // refresh the feed
        this.props.decTotal(-1);    // decrement total microposts count
      },
      error: (res) => {}
    });
  }

  showMicroposts() {
     return this.props.microposts.map((micropost) =>
        <li key={micropost.id} id={"micropost-" + micropost.id}>
          <ShowGravatar 
            username={micropost.user.username} 
            gravatar_id={micropost.user.gravatar_id} 
            size="50" 
          />
          <span className="user">
            <a href={"/users/" + micropost.user_id}>
              {micropost.user.username}
            </a>
          </span>
          <span className="content">{micropost.content}</span>
          <span className="timestamp">
            Posted: {micropost.created_at}
            <a href="#" 
              data-confirm="Are you sure?" 
              onClick={(e) => this.deleteMicropost(e, micropost.id)}> delete</a>
          </span>
        </li>
    );
  }

  render () {
  return <ol className="microposts">{this.showMicroposts()}</ol>
  }
}


ShowMicroposts.propTypes = {
  microposts: React.PropTypes.array,
  refreshFeed: React.PropTypes.func,
  decTotal: React.PropTypes.func
}
