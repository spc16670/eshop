
var eshopControllers = angular.module('eshop.admin.Controllers', []);


//--------------------------- mainController ---------------------------

eshopControllers.controller('ControllerAdmin', ['$scope','FactoryCategories',
  function($scope,FactoryCategories) { 

  $scope.categories = FactoryCategories.categories;
  $scope.categoriesMessage = FactoryCategories.message;
  $scope.promiseCategories = FactoryCategories.promise;

  $scope.togglerAdmin = {
    'showAdminStart':true
    ,'showAdminLook':false
    ,'showAdminCategories':false
    ,'showAdminItems':false
    ,'showAdminOffers':false
    ,'showAdminResult':false
  };

  $scope.$watch(function(){return FactoryCategories.state},function() {
     $scope.categories = FactoryCategories.categories;
     $scope.categoriesMessage = FactoryCategories.message;
     $scope.promiseCategories = FactoryCategories.promise;
  },true),

  $scope.$watch('$parent.toggler',function() {
    if ($scope.$parent.toggler.showAdmin == true) {
      FactoryCategories.fetchCategories();
    }
  },true),

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

