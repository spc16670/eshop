
var eshopControllers = angular.module('eshop.admin.categories.Controllers', []);

//------------------------- formShopController ------------------------

eshopControllers.controller('ControllerCategories', ['$scope','FactoryCategories',
  function($scope,FactoryCategories) {
  $scope.newCategory = { name: "", description: ""}; 

  $scope.inputValid = function(data, id) {
    if (data === "" || data == undefined) {
      return "Input cannot be empty";
    }
  };

//  $scope.fetchCategories = function() {
//    var categoriesShown = $scope.togglerAdmin.showAdminCategories;
//    if (categoriesShown == true) {
//      FactoryCategories.fetchCategories();
//      $scope.$parent.promiseCategories = FactoryCategories.promise; 
//    };
//  };

  $scope.removeCategory = function(index) {
    FactoryCategories.removeCategory(index);
    $scope.$parent.promiseCategories = FactoryCategories.promise; 
  };

  $scope.updateCategory = function(data,id) {
    FactoryCategories.updateCategory(data,id);
    $scope.$parent.promiseCategories = FactoryCategories.promise; 
  };

  $scope.addCategory = function() {
    if ($scope.formAddCategory.$valid) {
      FactoryCategories.addCategory($scope.newCategory);
      $scope.$parent.promiseCategories = FactoryCategories.promise; 
      $scope.formAddCategory.$setPristine();
      $scope.newCategory = { name: "", description: ""};
      $scope.showAddCategoryItemPanel = false; 
    } else { 
      alert("Please fill all fields in.");
    }
  };

}]);


