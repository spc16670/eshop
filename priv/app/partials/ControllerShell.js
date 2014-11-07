
var eshopControllers = angular.module('eshop.Controllers.Shell', []);

//---------------------- ControllerLanding ------------------------

eshopControllers.controller('ControllerShell', ['$scope',
  'FactoryAuth','FactoryPartials','$state',function($scope,
  FactoryAuth,FactoryPartials,$state) { 
 
  $scope.user = FactoryAuth.user;
  $scope.promisePartials = FactoryPartials.promise;

  $scope.$watch(function() {return FactoryAuth},function(){
    console.log('AUTH OBJECT CHANGED');
    $scope.user = FactoryAuth.user;
  },true);

  $scope.$watch(function() {return FactoryPartials.promise},function() {
    $scope.promisePartials = FactoryPartials.promise;
  });

  // Mutate the toggler object in accordance to user role 
//  $scope.$watch(function() {return FactoryAuth.user},function() {
    
//  }),

  $scope.logout = function() {
    FactoryAuth.logout();
//    $state.go('shell.shop');
  };

}]);

