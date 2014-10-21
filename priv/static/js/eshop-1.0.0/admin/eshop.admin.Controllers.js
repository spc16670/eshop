
var eshopControllers = angular.module('eshop.admin.Controllers', []);


//--------------------------- mainController ---------------------------

eshopControllers.controller('ControllerAdminMain', ['$scope','FactoryUser',
  function($scope, FactoryUser) { 
 
  $scope.currentUser = FactoryUser.authenticate({ 'operation': "initialize"});

  $scope.$watch(function() {return FactoryUser.loginPromise},function() {
    $scope.promiseLogin = FactoryUser.loginPromise;
  }),

  $scope.$watch(function() {return FactoryUser.user},function() {
    $scope.currentUser = FactoryUser.user;
    if ($scope.currentUser.isLogged) {
      $scope.visible('showCustomiseView');
    } else {
      $scope.visible('showLoginView');
    }
  }),

  $scope.logout = function() {
    FactoryUser.logout();
    $scope.visible('showLoginView');
  };

  // view display 
  $scope.toggler = {
    'showRegisterView':false
    ,'showCustomiseView':true
    ,'showLoginView':false
    ,'showBasketView':false
    ,'showPersonalView':false
  };
 
  $scope.visible = function(view) {
    for (var key in $scope.toggler) {
      if ($scope.toggler.hasOwnProperty(key)) {
        if (key !== view) {
	  if ($scope.toggler[key] == true) {
	    $scope.toggler[key] = false;
          }
        } else {
	  $scope.toggler[key] = true;
	}
      }
    }
  };
}]);

