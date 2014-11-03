
var eshopControllers = angular.module('eshop.admin.items.Controllers', []);

//------------------------- formShopController ------------------------

eshopControllers.controller('ControllerItems', ['$scope','FactoryItems',
  'FactoryRequest',function($scope,FactoryItems,FactoryRequest) {
  $scope.itemsMessage = "Fetching items...";
  $scope.items = []; 
  $scope.newItem = { name: "", description: ""}; 

  $scope.totalItems = 0;
  $scope.currentPage = 1;

//  $scope.$watch('$parent.items',function() {
//    $scope.items = $scope.$parent.items;
//    $scope.totalItems = $scope.$parent.items.length;
//  },true),


  $scope.setPage = function (pageNo) {
    $scope.currentPage = pageNo;
  };

  $scope.pageChanged = function() {
    console.log('Page changed to: ' + $scope.currentPage);
  };

  $scope.maxSize = 5;
  $scope.bigTotalItems = 100;
  $scope.bigCurrentPage = 1;
 
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


