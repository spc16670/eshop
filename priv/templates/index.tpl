<!doctype html>
<html lang="en" ng-app="eshopApp" ng-controller="MainController">
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="description" content="eshop website">
  <meta name="author" content="eshop">
  <title>Lamazone</title>
  <link rel="shortcut icon" href="/static/images/favicon.ico">
  <link rel="stylesheet" href="/static/css/bootstrap-3.1.1/bootstrap.min.css">
  <link rel="stylesheet" href="/static/css/animate-3.1.1/animate.css">
  <link rel="stylesheet" href="/static/css/eshop-1.0/eshop.css">
  <link rel="stylesheet" href="/static/css/angular-busy-4.0.0/angular-busy.min.css">
  <link rel="stylesheet" href="/static/css/angular-xeditable-0.1.8/xeditable.css">
  <script src="/static/js/jquery-1.11.1/jquery.min.js"></script>
  <script src="/static/js/bootstrap-3.1.1/bootstrap.min.js"></script>
  <script src="/static/js/bullet-0.4.1/bullet.js"></script>
  <script src="/static/js/angular-1.2.9/angular.min.js"></script>
  <script src="/static/js/angular-1.2.9/angular-route.js"></script>
  <script src="/static/js/angular-1.2.9/angular-animate.min.js"></script>
  <script src="/static/js/angular-busy-4.0.0/angular-busy.min.js"></script>
  <script src="/static/js/angular-xeditable-0.1.8/xeditable.min.js"></script>
  <script src="/static/js/eshop-1.0/eshop.js"></script>
  <script src="/static/js/eshop-1.0/eshop.controllers.js"></script>
  <script src="/static/js/eshop-1.0/eshop.directives.js"></script>
  <script src="/static/js/eshop-1.0/eshop.factories.js"></script>
  <script src="/static/js/eshop-1.0/eshop.services.js"></script>
  <!-- <script src="/static/js/angular-ui-0.11.0/ui-bootstrap.min.js"></script> -->
</head>
<body>
    
    <!-- Top Panel -->
    <div id="topPanel">
      {% include "topPanel.tpl" %}
    </div>

    <!-- Main Container --> 
    <div class="container-fluid">
      <div id="mainArea">

	<!-- Shop View -->
        <div id="shopView" ng-show="toggler.showShoppingView" ng-controller="ShopController">
	  {% include "shopView.tpl" %}
        </div> <!--/.shopView -->

        <!-- Login View -->
        <div id="loginView" ng-show="toggler.showLoginView" ng-controller="FormLoginController">
          {% include "loginView.tpl" %}
        </div> 
	
	<!-- Registration View -->
	<div id="registerView" ng-show="toggler.showSignUpView" ng-controller="FormSignUpController">
          {% include "registerView.tpl" %}
        </div>

	<!-- Personal Information View -->
        <div id="personalView" ng-show="toggler.showPersonalView" ng-controller="FormLoginController">
          {% include "personalView.tpl" %}
        </div>

      </div><!-- /.mainArea -->
    </div><!-- ./.container -->
  
  <div style="color:sienna">{{ sid }}</div>
  <div ng-model="sid" id="session_id" style="display:none">{{ sid }}</div>
  <div id="hostname" style="display:none">{{ hostname }}</div>
  <div id="client_timeout" style="display:none">{{ client_timeout }}</div>
</body>
</html>
