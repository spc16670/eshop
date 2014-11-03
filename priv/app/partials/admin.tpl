
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
      <div class="col-md-2 sidebar">
        <ul class="nav nav-sidebar">
          <li><br></li>
        </ul>
        <ul class="nav nav-sidebar">
          <!--<li class="active"><a href="#" ng-click="visibleAdmin('showAdminStart')">Get Started</a></li>-->
          <li class="active"><a ui-sref=".start">Get Started</a></li>
          <li><hr></hr></li>
        </ul>
        <ul class="nav nav-sidebar">
          <li><a href="#" ng-click="visibleAdmin('showAdminLook')">Look & Feel</a></li>
          <li><a href="#" ng-click="visibleAdmin('showAdminCategories')">Categories</a></li>
          <li><a href="#" ng-click="visibleAdmin('showAdminItems')">Items</a></li>
          <li><a href="#" ng-click="visibleAdmin('showAdminOffers')">Offers</a></li>
        </ul>
        <ul class="nav nav-sidebar">
          <li><hr></hr></li>
        </ul>
        <ul class="nav nav-sidebar">
        <li><a href="" ng-click="visibleAdmin('showAdminUsers')">Users</a></li>
        </ul>
      </div>

      <!-- Main Area -->
      <div class="col-md-10" id="main-area">
        <!-- Get Started -->
        <div id="adminStartView" ng-show="togglerAdmin.showAdminStart">
          <!-- {% include "adminStart.tpl" %} -->
        </div> <!--/.shopView -->

        <div id="adminLookView" ng-show="togglerAdmin.showAdminLook">
          {% include "adminLook.tpl" %}
        </div> <!--/.shopView -->


        <div id="adminCategoriesView" ng-controller="ControllerCategories" ng-show="togglerAdmin.showAdminCategories">
          {% include "adminCategories.tpl" %}
        </div> <!--/.shopView -->

        <div id="adminItemsView" ng-controller="ControllerItems" ng-show="togglerAdmin.showAdminItems">
          {% include "adminItems.tpl" %}
        </div> <!--/.shopView -->

        <div id="adminOffersView" ng-show="togglerAdmin.showAdminOffers">
          {% include "adminOffers.tpl" %}
        </div> <!--/.shopView -->


        <div id="adminUsersView" ng-show="togglerAdmin.showAdminUsers">
          {% include "adminUsers.tpl" %}
        </div> <!--/.shopView -->

      </div> <!-- col-md-10 -->
    </div><!-- row -->
  </div><!-- navabar -->
