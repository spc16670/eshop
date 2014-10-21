
var eshopControllers = angular.module('eshop.admin.customise.Controllers', []);

//------------------------- formShopController ------------------------

eshopControllers.controller('ControllerCustomise', ['$scope',function($scope) {
  
  // view display 
  $scope.shopToggler = {
    'showEmenuStart':true
    ,'showEmenuLook':false
    ,'showEmenuCategories':false
    ,'showEmenuItems':false
    ,'showEmenuOffers':false
    ,'showEmenuResult':false
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

