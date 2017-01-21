function FollowButton(props) {
  let text = props.is_following ? "Unfollow" : "Follow";
  let verb = props.is_following ? "DELETE" : "POST";
  return (
    <div id="follow_form">
      <button onClick={(e) => sendIt(e, verb)}>{text}</button>
    </div>
  )
}

function sendIt(e, verb) {
  e.preventDefault();
  $.ajax({
    method: verb,
    //data: { micropost: { content: this.state.value } },
    url: '/relationships',
    success: (res) => {
      // change these....
      this.setState({ value: '', errors: [] }); // reset the state
      this.props.refreshFeed(); // refresh the feed
      this.props.incTotal(1);    // increment total microposts count
      $('#micropost_submission_error').removeClass('alert alert-danger');
    },
    error: (res) => {
      this.setState({ errors: res.responseJSON.errors });
      $('#micropost_submission_error').addClass('alert alert-danger');
    }
  });
}
