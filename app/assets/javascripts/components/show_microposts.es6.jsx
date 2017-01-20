function ShowMicroposts(props) {
  const microposts = props.microposts.map((micropost) =>
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
        <span className="timestamp">Posted: {micropost.created_at}</span>
      </li>
  );
  return <ol className="microposts">{microposts}</ol>
}

ShowMicroposts.propTypes = {
  microposts: React.PropTypes.array
}
