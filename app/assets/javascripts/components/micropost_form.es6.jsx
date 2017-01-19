class MicropostForm extends React.Component {
  constructor(props) {
    super(props);
    this.state = { 
      value: '',
      errors: []
    };
    this.handleChange = this.handleChange.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  handleChange(event) {
    this.setState({ value: event.target.value });
  }

  handleSubmit(event) {
    event.preventDefault();
    $.ajax({
      method: 'POST',
      data: { micropost: { content: this.state.value } },
      url: '/microposts',
      success: (res) => {
        this.setState({ value: '', errors: [] }); // reset the state
        this.props.refreshFeed(); // refresh the feed
        this.props.incTotal();    // increment total microposts count
        $('#micropost_submission_error').removeClass('alert alert-danger');
      },
      error: (res) => {
        this.setState({ errors: res.responseJSON.errors });
        $('#micropost_submission_error').addClass('alert alert-danger');
      }
    });
  }

  render() {
    return (
      <form onSubmit={this.handleSubmit}>
        <div id="micropost_submission_error" >{this.state.errors}</div>
        <div className="field">
          <textarea placeholder="Compose a new micropost..." value={this.state.value} onChange={this.handleChange} />
        </div>
        <input id="post_button" className="btn btn-primary" type="submit" value="Post" />
      </form>
    );
  }
}
