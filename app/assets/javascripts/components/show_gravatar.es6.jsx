function ShowGravatar(props) {
  return (
    <img 
      className="gravatar" 
      alt={props.username}
      src={"https://secure.gravatar.com/avatar/" + props.gravatar_id + "?s=" + props.size} 
    />
  )
}

ShowGravatar.propTypes = {
  username: React.PropTypes.string,
  gravatar_id: React.PropTypes.string,
  size: React.PropTypes.string
};
