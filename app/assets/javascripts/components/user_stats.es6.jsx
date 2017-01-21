function UserStats(props) {
  return (
    <div className="stats">
      <a href={"/users/" + props.user.id + "/following"}>
        <strong id="following" className="stat">
          {props.user.following_count}
        </strong>
        following
      </a>
      <a href={"/users/" + props.user.id + "/followers"}>
        <strong id="followers" className="stat">
          {props.followers_count}
        </strong>
        followers
      </a>
    </div>
  );
}
