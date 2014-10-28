
var eshopControllers = angular.module('eshop.admin.Controllers', []);


//--------------------------- mainController ---------------------------

eshopControllers.controller('ControllerAdmin', ['$scope','FactoryCategories',
  'FactoryItems',function($scope,FactoryCategories,FactoryItems) { 

  // -- Categories
  $scope.categories = FactoryCategories.categories;
  $scope.categoriesMessage = FactoryCategories.message;
  $scope.promiseCategories = FactoryCategories.promise;
  $scope.selectedCategory = $scope.categories[0];

  $scope.$watch(function(){return FactoryCategories.state},function() {
     $scope.categories = FactoryCategories.categories;
     $scope.selectedCategory = $scope.categories[0];
     $scope.categoriesMessage = FactoryCategories.message;
     $scope.promiseCategories = FactoryCategories.promise;
  },true),

  // -- Items
  $scope.items = FactoryItems.items;
  $scope.itemsMessage = FactoryItems.message;
  $scope.itemsPromise = FactoryItems.promise;
  $scope.itemsStartRange = FactoryItems.offset;
  $scope.itemsEndRange = FactoryItems.limit;
  $scope.itemsCount = FactoryItems.count;

  $scope.$watch(function(){return FactoryItems.state},function() {
    $scope.items = FactoryCategories.items;
    $scope.itemsMessage = FactoryItems.message;
    $scope.itemsPromise = FactoryItems.promise;
    $scope.itemsStartRange = FactoryItems.offset;
    $scope.itemsEndRange = FactoryItems.limit;
    $scope.itemsCount = FactoryItems.count;
  },true),

  // -- Act in response to top level view change
  $scope.$watch('$parent.toggler',function() {
    if ($scope.$parent.toggler.showAdmin == true) {
      FactoryCategories.fetchCategories();
      FactoryItems.fetchItems($scope.itemsStartRange,$scope.itemsEndRange,$scope.selectedCategory);
    }
  },true),

  // -- Toggle Visibility Object
  $scope.togglerAdmin = {
    'showAdminStart':true
    ,'showAdminLook':false
    ,'showAdminCategories':false
    ,'showAdminItems':false
    ,'showAdminOffers':false
    ,'showAdminResult':false
  };

  // -- Toggle Visibility
  $scope.visibleAdmin = function(view) {
    for (var key in $scope.togglerAdmin) {
      if ($scope.togglerAdmin.hasOwnProperty(key)) {
        if (key !== view) {
	  if ($scope.togglerAdmin[key] == true) {
	    $scope.togglerAdmin[key] = false;
          }
        } else {
	  $scope.togglerAdmin[key] = true;
	}
      }
    }
  };
 
}]);

