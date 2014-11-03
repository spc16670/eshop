      <div id="mainArea">

	<!-- Shop View 
        <div id="shopView" ng-show="toggler.showShop" ng-controller="ControllerShop">
	  {% include "shopView.tpl" %}
        </div> -->
        <div id="shopView">
	  <div ui-view="shopView"></div>
        </div> 


	<!-- Customise View 
        <div id="adminView" ng-show="toggler.showAdmin" ng-controller="ControllerAdmin">
        </div> -->
        <div id="adminView">
	  <div ui-view="adminView"></div>
        </div> 


        <!-- Login View -->
        <div id="loginView" ng-show="toggler.showLogin" ng-controller="ControllerLogin">
          {% include "loginView.tpl" %}
        </div> 
	
	<!-- Registration View -->
	<div id="registerView" ng-show="toggler.showRegister" ng-controller="ControllerRegister">
          {% include "registerView.tpl" %}
        </div>

	<!-- Personal Information View -->
        <div id="personalView" ng-show="toggler.showPersonal" ng-controller="ControllerLogin">
          {% include "personalView.tpl" %}
        </div>

      </div><!-- /.mainArea -->

