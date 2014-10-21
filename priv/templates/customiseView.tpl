
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
          <li class="active"><a href="#" ng-click="shopVisible('showCustomiseStart')">Get Started</a></li>
          <li><hr></hr></li>
        </ul>
        <ul class="nav nav-sidebar">
          <li><a href="#" ng-click="shopVisible('showCustomiseLook')">Look & Feel</a></li>
          <li><a href="#" ng-click="shopVisible('showCustomiseCategories')">Categories</a></li>
          <li><a href="#" ng-click="shopVisible('showCustomiseItems')">Items</a></li>
          <li><a href="#" ng-click="shopVisible('showCustomiseOffers')">Offers</a></li>
        </ul>
        <ul class="nav nav-sidebar">
          <li><hr></hr></li>
        </ul>
        <ul class="nav nav-sidebar">
        <li><a href="" ng-click="shopVisible('showCustomiseResult')">Result</a></li>
        </ul>
      </div>

      <!-- Main Area -->
      <div class="col-md-10" id="main-area">
        <!-- Get Started -->
        <div id="customiseStartView" ng-show="shopToggler.showCustomiseStart">
          {% include "customiseStart.tpl" %}
        </div> <!--/.shopView -->

        <div id="customiseLookView" ng-show="shopToggler.showCustomiseLook">
          {% include "customiseLook.tpl" %}
        </div> <!--/.shopView -->


        <div id="customiseCategoriesView" ng-controller="ControllerCategories" ng-show="shopToggler.showCustomiseCategories">
          {% include "customiseCategories.tpl" %}
        </div> <!--/.shopView -->

        <div id="customiseItemsView" ng-show="shopToggler.showCustomiseItems">
          {% include "customiseItems.tpl" %}
        </div> <!--/.shopView -->

        <div id="customiseOffersView" ng-show="shopToggler.showCustomiseOffers">
          {% include "customiseOffers.tpl" %}
        </div> <!--/.shopView -->


        <div id="customiseResultView" ng-show="shopToggler.showCustomiseResult">
          {% include "customiseResult.tpl" %}
        </div> <!--/.shopView -->

      </div> <!-- col-md-10 -->
    </div><!-- row -->
  </div><!-- navabar -->
