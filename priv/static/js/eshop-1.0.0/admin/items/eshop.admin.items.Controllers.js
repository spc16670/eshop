
var eshopControllers = angular.module('eshop.admin.items.Controllers', []);

//------------------------- formShopController ------------------------

eshopControllers.controller('ControllerItems', ['$scope','FactoryItems',
  'FactoryRequest',function($scope,FactoryItems,FactoryRequest) {
  $scope.itemsMessage = "Fetching items...";
  $scope.items = []; 
  $scope.newItem = { name: "", description: ""}; 
  

  $scope.inputValid = function(data, id) {
    if (data === "" || data == undefined) {
      return "Input cannot be empty";
    }
  };


  $scope.selectedCategory = function(category) {
    $scope.$parent.selectedCategory = category;
  };

  $scope.fetchItems = function(startRange,endRange) {
  };

  $scope.removeItem = function(index) {
  };

  $scope.updateItem = function(data, id) {
  };

  $scope.addItem = function() {
  };

}]);


