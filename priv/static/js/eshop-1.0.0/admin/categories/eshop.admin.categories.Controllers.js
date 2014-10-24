
var eshopControllers = angular.module('eshop.admin.categories.Controllers', []);

//------------------------- formShopController ------------------------

eshopControllers.controller('ControllerCategories', ['$scope','FactoryBullet',
  'FactoryRequest','FactoryCategories',function($scope,FactoryBullet,
  FactoryRequest,FactoryCategories) {
  $scope.categoriesMessage = "Fetching categories...";
  $scope.categories = FactoryCategories.categories; 
  $scope.newCategory = { name: "", description: ""}; 
  
  $scope.$watch('togglerAdmin',function() {
    $scope.fetchCategories();
  },true),

  $scope.$watch(function(){return FactoryCategories.state},function() {
     $scope.categories = FactoryCategories.categories;
     $scope.categoriesMessage = FactoryCategories.message;
     $scope.promiseCategories = FactoryCategories.promise; 
     console.log('Message is: ',$scope.categoriesMessage);
  },true),

  $scope.inputValid = function(data, id) {
    if (data === "" || data == undefined) {
      return "Input cannot be empty";
    }
  };

  $scope.fetchCategories = function() {
    var categoriesShown = $scope.togglerAdmin.showAdminCategories;
    if (categoriesShown == true) {
      FactoryCategories.fetchCategories();
      $scope.promiseCategories = FactoryCategories.promise; 
    };
  };

  $scope.removeCategory = function(index) {
    FactoryCategories.removeCategory(index);
    $scope.promiseCategories = FactoryCategories.promise; 
  };

  $scope.updateCategory = function(data,id) {
    FactoryCategories.updateCategory(data,id);
    $scope.promiseCategories = FactoryCategories.promise; 
  };

  $scope.addCategory = function() {
    if ($scope.formAddCategory.$valid) {
      FactoryCategories.addCategory($scope.newCategory);
      $scope.promiseCategories = FactoryCategories.promise; 
      $scope.formAddCategory.$setPristine();
      $scope.newCategory = { name: "", description: ""};
      $scope.showAddCategoryItemPanel = false; 
    } else { 
      alert("Please fill all fields in.");
    }
  };

}]);


