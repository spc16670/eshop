
var eshopControllers = angular.module('eshop.Controller.Login', []);

//---------------------- ControllerLanding ------------------------

eshopControllers.controller('ControllerLogin', ['$scope',
  'FactoryAuth','FactoryAlert','FactoryRequest','$state',
  function($scope,FactoryAuth,FactoryAlert,FactoryRequest,$state) {

  $scope.login = {};
  $scope.alerts = [];

  $scope.closeAlert = function(index) {
    $scope.alerts.splice(index, 1);
  }

  $scope.$watch(function() {return FactoryAuth},function() {
    $scope.user = FactoryAuth.user;
    if ($scope.user.attempt !== "ok") {
      handleError($scope.user.msg);
    } else {
      if ($scope.user.isLogged) {
        $state.go('shell.shop');
      }
    }
  },true);
 
  function handleError(msg) {
     while($scope.alerts.length > 0) {
      $scope.alerts.pop();
    }
    $scope.alerts.push(FactoryAlert.makeAlert("danger",msg));  
  };

  try {
    $scope.submit = function () {
      if ($scope.loginForm.$valid) {
        var loginReq = { 'type': "user", 'action' : "authenticate", 'data' : $scope.login };
        var request = FactoryRequest.makeRequest("login",loginReq,false); 
        FactoryAuth.authenticate(request);
        $scope.login = {};
        $scope.loginForm.$setPristine();
      }
    };
  } catch(e) {
    console.log(e);
  }
  
}]);


