
var eshopControllers = angular.module('eshop.admin.categories.Controllers', []);

//------------------------- formShopController ------------------------

eshopControllers.controller('ControllerCategories', ['$scope','FactoryBullet',
  'FactoryRequest',function($scope,FactoryBullet,FactoryRequest) {
  $scope.categoriesMessage = "Fetching categories...";
  $scope.categories = []; 
  $scope.newCategory = { name: "", description: ""}; 
  

  $scope.$watch('togglerAdmin',function() {
    $scope.fetchCategories();
  },true),

  $scope.inputValid = function(data, id) {
    if (data === "" || data == undefined) {
      return "Input cannot be empty";
    }
  };

  $scope.fetchCategories = function() {
    var categoriesShown = $scope.togglerAdmin.showAdminCategories;
    if (categoriesShown == true) {
      // Refresh categories list
      $scope.categories = [];
      var fetchReq = { 'type': "category", 'action' : "fetch" };
      var request = FactoryRequest.makeRequest("categories",fetchReq,true);
      var promise = FactoryBullet.send(request);
      $scope.promiseCategories = promise;
      promise.then(function(response) {
        if (response.operation === "categories") {
	  if (response.data.result == "ok") {
	    $scope.categories = response.data.data;
	  } else {
	    $scope.categoriesMessage = response.data.msg;
          }
          console.log('Category: ',response.data);
        } else {
          console.log('Invalid response: ',response);
        }
      });
    };
  };

  $scope.removeCategory = function(index) {
    var removeCat = $scope.categories[index].data; 
    var deleteReq = { 'type': "category", 'action' : "delete", 'data' : removeCat };
    var request = FactoryRequest.makeRequest("categories",deleteReq,true); 
    var promise = FactoryBullet.send(request);
    console.log("Deleting Category: ",removeCat);
    // This is needed to display the loading dialog
    $scope.promiseCategories = promise;
    promise.then(function(response) {
      if (response.operation === "categories") {
        if (response.data.result == "ok") {
          $scope.fetchCategories();
          console.log('Category Modified ',response.data.msg);
        } else {
          console.log('Could not modify ',response.data.msg);
          $scope.categoriesMessage = response.data.msg;
          $scope.categories = [];
        }
      } else {
        console.log('Invalid response: ',response);
      }
    });
  };

  $scope.updateCategory = function(data, id) {
    angular.extend(data, {id: id});
    var upsertReq = { 'type': "category", 'action' : "upsert", 'data' : data };
    var request = FactoryRequest.makeRequest("categories",upsertReq,true); 
    var promise = FactoryBullet.send(request);
    // This is needed to display the loading dialog
    $scope.promiseCategories = promise;
    promise.then(function(response) {
      if (response.operation === "categories") {
        if (response.data.result == "ok") {
          $scope.fetchCategories();
          console.log('Category Modified ',response.data);
        } else {
          console.log('Could not modify ',response.data);
          $scope.categoriesMessage = response.data.msg;
	  $scope.categories = [];
        }
      } else {
        console.log('Invalid response: ',response);
      }
    });
  };


  $scope.addCategory = function() {
    if ($scope.formAddCategory.$valid) {
      var addReq = { 'type': "category", 'action' : "add", 'data' : $scope.newCategory };
      var request = FactoryRequest.makeRequest("categories",addReq,true); 
      var promise = FactoryBullet.send(request);
      console.log("Submitting new Category: ",addReq);
      $scope.promiseCategories = promise;
      promise.then(function(response) {
        if (response.operation === "categories") {
          if (response.data.result == "ok") {
	    $scope.formAddCategory.$setPristine();
	    $scope.newCategory = { name: "", description: ""};
            $scope.showAddCategoryItemPanel = false; 
            console.log('New Category added ',response.data);
            $scope.fetchCategories();
          } else {
            console.log('Could not add new category ',response.data);
            $scope.categoriesMessage = response.data.msg;
	    $scope.categories = [];
          }
        } else {
          console.log('Invalid response: ',response);
        }
      }); 
    } else { 
      alert("Please fill all fields in.");
    }
  };

}]);


