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
            <img className="gravatar" alt={this.props.user.name}
            src={"https://secure.gravatar.com/avatar/" + this.props.user.gravatar_id + "?s=#50"} />
            <h1>{this.props.user.name}</h1>
            <span>
                View my profile
            </span>
          </section>
        </aside>
      </div>
    );  
  }     
}
