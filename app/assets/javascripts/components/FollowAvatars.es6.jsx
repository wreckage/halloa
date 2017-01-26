function FollowAvatars(props) {
  const gravatars = props.users.map((user) =>
    <a key={user.id} href={"/users/" + user.id} title={user.username}>
      <ShowGravatar 
        username={user.username} 
        gravatar_id={user.gravatar_id} 
        size="30" 
      />
    </a>
  );
  return <div className="user_avatars">{gravatars}</div>
}

FollowAvatars.propTypes = {
  users: React.PropTypes.array
}
