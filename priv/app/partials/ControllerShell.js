
var eshopControllers = angular.module('eshop.Controllers', []);

//---------------------- ControllerLanding ------------------------

eshopControllers.controller('ControllerShell', ['$scope','FactoryAuth',
  '$state',function($scope, FactoryAuth, $state) { 
 
  $scope.user = FactoryAuth.user;

  $scope.$watch(function() {return FactoryAuth.loginPromise},function() {
    $scope.promiseLogin = FactoryAuth.loginPromise;
  });

  // Mutate the toggler object in accordance to user role 
  $scope.$watch(function() {return FactoryAuth.user},function() {
    
  }),

  $scope.logout = function() {
    FactoryAuth.logout();
    $state.go('shell.shop');
  };

}]);

