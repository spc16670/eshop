
var eshopControllers = angular.module('eshop.Controller.Main', []);

//---------------------- ControllerLanding ------------------------

eshopControllers.controller('ControllerMain', ['$scope',
  'FactoryCategories','$state',function($scope,
  FactoryCategories,$state) { 

  $scope.categories = [];
  $scope.items = []; 
  // Mutate the toggler object in accordance to user role 
  $scope.$watch(function() {return FactoryCategories},function() {
     $scope.categories = FactoryCategories.categories;
     $scope.promise = FactoryCategories.promise;
  })

  
}]);

