class Home extends React.Component {
  constructor(props) {
    super(props);
  }

  handleButton(event) {
    event.preventDefault();
    $.ajax({
      method: 'GET',
      data: {
      },
      url: '/users/sign_up',
      success: (res) => {
        console.log("hello!");
      },
      error: (res) => {
        console.log("AHH");
      }
    });
  }

  render() {
    return (
      <div>
        <h1>Hello World from inside home component!</h1>
        <button onClick={this.handleButton}>Click Me</button>
      </div>
    );
  }
}

