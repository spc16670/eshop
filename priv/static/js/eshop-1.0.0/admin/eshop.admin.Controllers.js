
var eshopControllers = angular.module('eshop.admin.Controllers', []);


//--------------------------- mainController ---------------------------

eshopControllers.controller('ControllerAdmin', ['$scope','FactoryCategories',
  'FactoryItems',function($scope,FactoryCategories,FactoryItems) { 

  /*
  * The basic idea here is to:
  * 1) Fetch categories on the showing of the page
  * 2) Fetch items on the changing of the categories variable
  * 3) Fetch items on the changing of the selectedCategory variable
  *
  */

  // -- Categories
  $scope.categories = FactoryCategories.categories;
  $scope.categoriesMessage = FactoryCategories.message;
  $scope.promiseCategories = FactoryCategories.promise;
  $scope.selectedCategory = $scope.categories[0]; // MODIFIED FROM THE ITEM CHILD SCOPE

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
  $scope.itemsOffset = FactoryItems.offset;
  $scope.itemsLimit = FactoryItems.limit;
  $scope.itemsCount = FactoryItems.count;

  $scope.$watch(function(){return FactoryItems.state},function() {
    $scope.items = FactoryItems.items;
    $scope.itemsMessage = FactoryItems.message;
    $scope.itemsPromise = FactoryItems.promise;
    $scope.itemsOffset = FactoryItems.offset;
    $scope.itemsLimit = FactoryItems.limit;
    $scope.itemsCount = FactoryItems.count;
  },true),

  // -- Act in response to top level view change
  $scope.$watch('$parent.toggler',function() {
    if ($scope.$parent.toggler.showAdmin == true) {
      FactoryCategories.fetchCategories();
    }
  },true),
  // -- Act in response to categories change
  $scope.$watch('categories',function() {
    if ($scope.categories.length > 0) {
      FactoryItems.fetchItems($scope.itemsOffset,$scope.itemsLimit,$scope.selectedCategory.data.id);
    }
  },true),
  // -- Act in response to selectedCategory change triggerred from the ITEM CHILD SCOPE
  $scope.$watch('selectedCategory',function() {
    if ($scope.selectedCategory != null || $scope.selectedCategory != undefined) {
      FactoryItems.fetchItems($scope.itemsOffset,$scope.itemsLimit,$scope.selectedCategory.data.id);
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

