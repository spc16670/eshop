<!doctype html>
<html lang="en" ng-app="EShop">
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="description" content="eshop website">
  <meta name="author" content="eshop">
  <title>Lamazone</title>
  <link rel="shortcut icon" href="/static/images/favicon.ico">
  <link rel="stylesheet" href="/static/css/bootstrap/bootstrap-3.1.1.min.css">
  <link rel="stylesheet" href="/static/css/animate/animate-3.1.1.css">
  <link rel="stylesheet" href="/static/css/eshop/eshop.css">
  <link rel="stylesheet" href="/static/css/angular-busy/angular-busy-4.0.0.min.css">
  <link rel="stylesheet" href="/static/css/angular-xeditable/xeditable-0.1.8.css">
  <script src="/static/js/jquery/jquery-1.11.1.min.js"></script>
  <!-- <script src="/static/js/bootstrap-3.1.1/bootstrap.min.js"></script> -->
  <script src="/static/js/bullet/bullet-0.4.1.js"></script>
  <script src="/static/js/angular/angular-1.2.9.min.js"></script>
  <!--<script src="/static/js/angular/angular-route-1.2.9.js"></script>-->
  <script src="/static/js/angular/angular-animate-1.2.9.min.js"></script>
  <script src="/static/js/angular-ui/ui-bootstrap-tpls-0.11.0.min.js"></script>
  <script src="/static/js/angular-busy/angular-busy-4.0.0.min.js"></script>
  <script src="/static/js/angular-xeditable/xeditable-0.1.8.min.js"></script>
  <script src="/static/js/angular-ui-router/angular-ui-router-0.2.11.js"></script>

<!--  <script src="/static/js/eshop/admin/categories/eshop.admin.categories.Controllers.js"></script>
  <script src="/static/js/eshop/admin/categories/eshop.admin.categories.Factories.js"></script>
  <script src="/static/js/eshop/admin/items/eshop.admin.items.Controllers.js"></script>
  <script src="/static/js/eshop/admin/items/eshop.admin.items.Factories.js"></script>
  <script src="/static/js/eshop/admin/eshop.admin.Controllers.js"></script>
  <script src="/static/js/eshop/eshop.Directives.js"></script>
  <script src="/static/js/eshop/eshop.Controllers.js"></script>
-->
  
  <script src="/app/directives/DirectiveValidate.js"></script>
  <script src="/app/factories/Factory.js"></script>
  <script src="/app/factories/FactoryCategories.js"></script>
  <script src="/app/partials/ControllerShell.js"></script>
  <script src="/app/partials/ControllerSignUp.js"></script>
  <script src="/app/partials/ControllerMain.js"></script>
  <script src="/app/partials/ControllerLogin.js"></script>
  <script src="/app/app.js"></script>
  <!-- <script src="/static/js/angular-ui-0.11.0/ui-bootstrap.min.js"></script> -->
</head>
<body ng-controller="ControllerShell">
    
    <!-- Top Panel -->
    <div id="topPanel" cg-busy="busyMain">
      {% include "top.tpl" %}
    </div>
    
    <!-- Main Container --> 
    <div class="container-fluid">
      <div ui-view></div> 
      {% include "main.tpl" %}
    </div><!-- ./.container -->
  
  <div style="color:sienna">{{ sid }}</div>
  <div id="session_id" style="display:none">{{ sid }}</div>
  <div id="hostname" style="display:none">{{ hostname }}</div>
  <div id="client_timeout" style="display:none">{{ client_timeout }}</div>
</body>
</html>
