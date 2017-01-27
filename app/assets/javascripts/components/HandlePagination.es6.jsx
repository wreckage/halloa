function HandlePagination(props) {
  const scroll_up = props.scroll_up;
  return (
    <ul className="pagination">
      {props.page > 1 &&
        <li className="previous previous_page ">
          <a href="#" onClick={(e) => { props.fetchIt(e, "prev"); scrollUp(scroll_up) } }>&#8592;Prev</a>
        </li>
      }
      {props.next_page > 0 &&
        <li className="next next_page ">
          <a href="#" onClick={(e) => { props.fetchIt(e, "next"); scrollUp(scroll_up) } }>Next &#8594;</a>
        </li>
      }
    </ul>
    );
}

function scrollUp(scroll) {
  if (scroll) {
    $("html, body").animate({ scrollTop: 0 }, "slow");
  }
}

HandlePagination.propTypes = {
  page: React.PropTypes.number,
  next_page: React.PropTypes.number,
  fetchIt: React.PropTypes.func,
  scroll_up: React.PropTypes.bool
}
