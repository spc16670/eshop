
var eshopControllers = angular.module('eshop.Controller.Shell', []);

//---------------------- ControllerLanding ------------------------

eshopControllers.controller('ControllerShell', ['$scope',
  'FactoryBullet','FactoryAuth','$state',
  function($scope,FactoryBullet,FactoryAuth,$state) { 
  console.log('current STATE::::',$state.current); 
  $scope.user = FactoryAuth.user;
  $scope.busyMain = FactoryBullet.promise;

  $scope.$watch(function() {return FactoryBullet.cid},function(){
    $scope.busyMain = FactoryBullet.promise;
  },true);

  $scope.$watch(function() {return FactoryAuth},function(){
    $scope.user = FactoryAuth.user;
  },true);

  $scope.logout = function() {
    FactoryAuth.logout();
  };

}]);

