<!doctype html>
<html lang="en" ng-app="AppAdmin" ng-controller="ControllerAdminMain">
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
  <link rel="stylesheet" href="/static/css/eshop-1.0.0/eshop.css">
  <link rel="stylesheet" href="/static/css/angular-busy-4.0.0/angular-busy.min.css">
  <link rel="stylesheet" href="/static/css/angular-xeditable-0.1.8/xeditable.css">
  <script src="/static/js/jquery-1.11.1/jquery.min.js"></script>
  <!-- <script src="/static/js/bootstrap-3.1.1/bootstrap.min.js"></script> -->
  <script src="/static/js/bullet-0.4.1/bullet.js"></script>
  <script src="/static/js/angular-1.2.9/angular.min.js"></script>
  <script src="/static/js/angular-1.2.9/angular-route.js"></script>
  <script src="/static/js/angular-1.2.9/angular-animate.min.js"></script>
  <script src="/static/js/angular-ui-0.11.0/ui-bootstrap-tpls-0.11.0.min.js"></script>
  <script src="/static/js/angular-busy-4.0.0/angular-busy.min.js"></script>
  <script src="/static/js/angular-xeditable-0.1.8/xeditable.min.js"></script>

  <script src="/static/js/eshop-1.0.0/admin/customise/categories/eshop.admin.customise.categories.Controllers.js"></script>
  <script src="/static/js/eshop-1.0.0/admin/customise/items/eshop.admin.customise.items.Controllers.js"></script>
  <script src="/static/js/eshop-1.0.0/admin/customise/eshop.admin.customise.Controllers.js"></script>
  <script src="/static/js/eshop-1.0.0/admin/eshop.admin.Controllers.js"></script>
  <script src="/static/js/eshop-1.0.0/admin/eshop.admin.App.js"></script>
  <script src="/static/js/eshop-1.0.0/eshop.Directives.js"></script>
  <script src="/static/js/eshop-1.0.0/eshop.Controllers.js"></script>
  <script src="/static/js/eshop-1.0.0/eshop.Factories.js"></script>
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

	<!-- Customise View -->
        <div id="shopView" ng-show="toggler.showCustomiseView" ng-controller="ControllerCustomise">
	  {% include "customiseView.tpl" %}
        </div>

        <!-- Login View -->
        <div id="loginView" ng-show="toggler.showLoginView" ng-controller="ControllerLogin">
          {% include "loginView.tpl" %}
        </div> 
	
	<!-- Registration View -->
	<div id="registerView" ng-show="toggler.showRegisterView" ng-controller="ControllerRegister">
          {% include "registerView.tpl" %}
        </div>

	<!-- Personal Information View -->
        <div id="personalView" ng-show="toggler.showPersonalView" ng-controller="ControllerLogin">
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
