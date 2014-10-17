
var eshopApp = angular.module('eshopApp', [
  'ngRoute'
  ,'ngAnimate'
  ,'eshopControllers'
  ,'eshopDirectives'
  ,'eshopFactories'
  ,'xeditable'
  ,'cgBusy'
]);

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
      controller  : 'mainController',
      animation : 'slide'
    })
});



