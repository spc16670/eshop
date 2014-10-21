
var eshopControllers = angular.module('eshop.admin.customise.Controllers', []);

//------------------------- formShopController ------------------------

eshopControllers.controller('ControllerCustomise', ['$scope',function($scope) {
  
  // view display 
  $scope.shopToggler = {
    'showCustomiseStart':true
    ,'showCustomiseLook':false
    ,'showCustomiseCategories':false
    ,'showCustomiseItems':false
    ,'showCustomiseOffers':false
    ,'showCustomiseResult':false
  };

  $scope.shopVisible = function(view) {
    for (var key in $scope.shopToggler) {
      if ($scope.shopToggler.hasOwnProperty(key)) {
        if (key !== view) {
          if ($scope.shopToggler[key] == true) {
            $scope.shopToggler[key] = false;
          }
        } else {
          $scope.shopToggler[key] = true;
        }
      }
    }
  };
}]);

