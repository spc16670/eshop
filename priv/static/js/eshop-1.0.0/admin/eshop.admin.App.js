
var eshopApp = angular.module('AppAdmin', [
  'ngRoute'
  ,'ngAnimate'
  ,'ui.bootstrap'
  ,'eshop.Controllers'
  ,'eshop.admin.Controllers'
  ,'eshop.admin.customise.Controllers'
  ,'eshop.admin.customise.categories.Controllers'
  ,'eshop.Directives'
  ,'eshop.Factories'
  ,'xeditable'
  ,'cgBusy'
]);

eshopApp.config(function($interpolateProvider){
  $interpolateProvider.startSymbol('{[').endSymbol(']}');
});

// Needed for xeditable
eshopApp.run(function(editableOptions) {
  editableOptions.theme = 'bs3'; // bootstrap3 theme. Can be also 'bs2', 'default'
});

// configure our routes
eshopApp.config(function($routeProvider) {
  $routeProvider
    // route for the home page
    .when('/', {
      template : " ",
      controller  : 'ControllerAdminMain',
      animation : 'slide'
    })
});



