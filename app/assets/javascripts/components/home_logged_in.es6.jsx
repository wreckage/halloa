class HomeLoggedIn extends React.Component {
  constructor(props) {         
    super(props);              
  }

  componentDidMount() {
    //$.getJSON('/user.json', (data) => this.setState({ user: data }))
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
              <a href={"/users/" + this.props.user.id}>View my profile</a>
            </span>
            <span>
              Microposts ({this.props.micropost_total})
            </span>
          </section>
        </aside>
      </div>
    );  
  }     
}
