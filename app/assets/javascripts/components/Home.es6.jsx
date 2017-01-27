function Home(props) {
  return (
    <div className="center jumbotron">
      <h1>Halloa!</h1>
      <h3>
        <a href="/users/sign_in">Sign in</a> to start posting!
      </h3>
      <h2>Not a user? <a href="/users/sign_up">Join!</a></h2>
    </div>
  );
}
