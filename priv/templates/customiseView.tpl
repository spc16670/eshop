
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
          <li class="active"><a href="#" ng-click="shopVisible('showEmenuStart')">Get Started</a></li>
          <li><hr></hr></li>
        </ul>
        <ul class="nav nav-sidebar">
          <li><a href="#" ng-click="shopVisible('showEmenuLook')">Look & Feel</a></li>
          <li><a href="#" ng-click="shopVisible('showEmenuCategories')">Categories</a></li>
          <li><a href="#" ng-click="shopVisible('showEmenuItems')">Items</a></li>
          <li><a href="#" ng-click="shopVisible('showEmenuOffers')">Offers</a></li>
        </ul>
        <ul class="nav nav-sidebar">
          <li><hr></hr></li>
        </ul>
        <ul class="nav nav-sidebar">
        <li><a href="" ng-click="shopVisible('showEmenuResult')">Result</a></li>
        </ul>
      </div>

      <!-- Main Area -->
      <div class="col-md-10" id="main-area">
        <!-- Get Started -->
        <div id="emenuStartView" ng-show="shopToggler.showEmenuStart">
          {% include "emenuStart.tpl" %}
        </div> <!--/.shopView -->

        <div id="emenuLookView" ng-show="shopToggler.showEmenuLook">
          {% include "emenuLook.tpl" %}
        </div> <!--/.shopView -->


        <div id="emenuCategoriesView" ng-controller="ControllerCategories" ng-show="shopToggler.showEmenuCategories">
          {% include "emenuCategories.tpl" %}
        </div> <!--/.shopView -->

        <div id="emenuItemsView" ng-show="shopToggler.showEmenuItems">
          {% include "emenuItems.tpl" %}
        </div> <!--/.shopView -->

        <div id="emenuOffersView" ng-show="shopToggler.showEmenuOffers">
          {% include "emenuOffers.tpl" %}
        </div> <!--/.shopView -->


        <div id="emenuResultView" ng-show="shopToggler.showEmenuResult">
          {% include "emenuResult.tpl" %}
        </div> <!--/.shopView -->

      </div> <!-- col-md-10 -->
    </div><!-- row -->
  </div><!-- navabar -->
