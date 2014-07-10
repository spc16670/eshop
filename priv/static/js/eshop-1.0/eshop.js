
var eshopApp = angular.module('eshopApp', [
  'ngRoute'
  ,'ngAnimate'
  ,'eshopControllers'
  ,'eshopDirectives'
  ,'eshopFactories'
]);

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



