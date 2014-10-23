
var eshopControllers = angular.module('eshop.admin.Controllers', []);


//--------------------------- mainController ---------------------------

eshopControllers.controller('ControllerAdmin', ['$scope','FactoryUser',
  function($scope, FactoryUser) { 

  $scope.togglerAdmin = {
    'showAdminStart':true
    ,'showAdminLook':false
    ,'showAdminCategories':false
    ,'showAdminItems':false
    ,'showAdminOffers':false
    ,'showAdminResult':false
  };
 
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

