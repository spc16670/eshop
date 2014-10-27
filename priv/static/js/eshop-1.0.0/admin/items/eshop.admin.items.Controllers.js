
var eshopControllers = angular.module('eshop.admin.items.Controllers', []);

//------------------------- formShopController ------------------------

eshopControllers.controller('ControllerItems', ['$scope','FactoryBullet',
  'FactoryRequest',function($scope,FactoryBullet,FactoryRequest) {
  $scope.itemsMessage = "Fetching items...";
  $scope.items = []; 
  $scope.newItem = { name: "", description: ""}; 
  

  $scope.inputValid = function(data, id) {
    if (data === "" || data == undefined) {
      return "Input cannot be empty";
    }
  };

  $scope.fetchItems = function() {
  };

  $scope.removeItem = function(index) {
  };

  $scope.updateItem = function(data, id) {
  };


  $scope.addItem = function() {
  };

}]);


