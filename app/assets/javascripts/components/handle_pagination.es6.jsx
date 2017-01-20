function HandlePagination(props) {
  return (
    <ul className="pagination">
      {props.page > 1 &&
        <li className="previous previous_page ">
          <a href="#" onClick={(e) => props.fetchIt(e, "prev")}>&#8592;Prev</a>
        </li>
      }
      {props.next_page > 0 &&
        <li className="next next_page ">
          <a href="#" onClick={(e) => props.fetchIt(e, "next")}>Next &#8594;</a>
        </li>
      }
    </ul>
    );
}

HandlePagination.propTypes = {
  page: React.PropTypes.number,
  next_page: React.PropTypes.number,
  fetchIt: React.PropTypes.func
}
