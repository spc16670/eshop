  <div class="col-md-2 sidebar" cg-busy="promiseCategories">
    <ul class="nav nav-sidebar">
      <li class="active">
	<a href="#">Welcome</a></li>
      <li><hr></hr></li>
    </ul>
    <ul class="nav nav-sidebar" ng-show="!categories.length">
      <li>
	<p>No Categories</p> 
      </li>
    </ul>
    <ul class="nav nav-sidebar" role="navigation" ng-repeat="category in categories">
      <li ng-class="{ active: true }">
	<a href="#" ng-click="visible(category)">{[ category.data.name ]}</a>
      </li>
    </ul>
    <ul class="nav nav-sidebar">
      <li>
	<hr></hr>
      </li>
    </ul>
    <ul class="nav nav-sidebar">
      <li>
	<a href="">All</a>
      </li>
    </ul>
  </div>

