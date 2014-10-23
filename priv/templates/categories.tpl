  <div class="col-md-2 sidebar">
    <ul class="nav nav-sidebar">
      <li class="active"><a href="#">Welcome</a></li>
      <li><hr></hr></li>
    </ul>
    <ul class="nav nav-sidebar" ng-repeat="category in categories">
      <li><a href="#">{[ category.data.name ]}</a></li>
    </ul>
    <ul class="nav nav-sidebar">
      <li><hr></hr></li>
    </ul>
    <ul class="nav nav-sidebar">
      <li><a href="">All</a></li>
    </ul>
  </div>

