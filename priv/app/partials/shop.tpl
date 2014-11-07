
  <div class="navbar navbar-default" role="navigation">
    <!-- Search 
    <div class="row">
      <div class="col-md-2 navbar-header">
        <a class="navbar-brand"></a>
      </div>
      <div class="col-md-6">
        <form class="navbar-form" role="search">
            <div class="input-group">
              <input type="text" id="search-input" class="form-control" placeholder="Search">
                <span class="input-group-addon">
                  <a href="">Go</a>
                </span>
            </div>
        </form>
      </div>
      <div class="col-md-4">
        <button type="button" class="btn btn-default navbar-btn">
          Button
        </button>
      </div>
    </div> -->

    <div class="row">

      <!-- Menu -->
      <div class="col-md-2 sidebar" cg-busy="promiseCategories">

	<ul class="nav nav-sidebar">
	  <li class="active">
	    <a href="#">Welcome</a></li>
	  <li>
	    <hr></hr>
	  </li>
	</ul>

	<ul class="nav nav-sidebar" ng-show="!categories.length">
	  <li>
	    <p>No Categories</p>
	  </li>
	</ul>

	<ul class="nav nav-sidebar" role="navigation" ng-repeat="category in categories">
	  <li ng-class="{ active: true }">
	    <a href="#" ng-click="">{[ category.data.name ]}</a>
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

      <!-- Main Area -->
      <div class="col-md-10" id="main-area">
        {[ $parent.user ]}
        {% include "items.tpl" %}
      </div> <!-- col-md-10 -->
    </div><!-- row -->
  </div><!-- navabar -->
