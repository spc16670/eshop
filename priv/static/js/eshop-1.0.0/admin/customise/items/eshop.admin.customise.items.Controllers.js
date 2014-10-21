
var eshopControllers = angular.module('eshop.admin.customise.items.Controllers', []);

//------------------------- formShopController ------------------------

eshopControllers.controller('ControllerItems', ['$scope','FactoryBullet',
  'FactoryRequest',function($scope,FactoryBullet,FactoryRequest) {
  $scope.itemsMessage = "Fetching items...";
  $scope.items = []; 
  $scope.newItem = { name: "", description: ""}; 
  

  $scope.$watch('shopToggler',function() {
    $scope.fetchItems();
  },true),

  $scope.inputValid = function(data, id) {
    if (data === "" || data == undefined) {
      return "Input cannot be empty";
    }
  };

  $scope.fetchItems = function() {
    var itemsShown = $scope.shopToggler.showCustomiseItems;
    if (itemsShown == true) {
      // Refresh items list
      $scope.items = [];
      var fetchReq = { 'type': "category", 'action' : "fetch" };
      var request = FactoryRequest.makeRequest("items",fetchReq,true);
      var promise = FactoryBullet.send(request);
      $scope.promiseCategories = promise;
      promise.then(function(response) {
        if (response.operation === "items") {
	  if (response.data.result == "ok") {
	    $scope.items = response.data.data;
	  } else {
	    $scope.itemsMessage = response.data.msg;
          }
          console.log('Category: ',response.data);
        } else {
          console.log('Invalid response: ',response);
        }
      });
    };
  };

  $scope.removeItem = function(index) {
    var removeCat = $scope.items[index].data; 
    var deleteReq = { 'type': "category", 'action' : "delete", 'data' : removeCat };
    var request = FactoryRequest.makeRequest("items",deleteReq,true); 
    var promise = FactoryBullet.send(request);
    console.log("Deleting Category: ",removeCat);
    // This is needed to display the loading dialog
    $scope.promiseItems = promise;
    promise.then(function(response) {
      if (response.operation === "items") {
        if (response.data.result == "ok") {
          $scope.fetchCategories();
          console.log('Category Modified ',response.data.msg);
        } else {
          console.log('Could not modify ',response.data.msg);
          $scope.itemsMessage = response.data.msg;
          $scope.items = [];
        }
      } else {
        console.log('Invalid response: ',response);
      }
    });
  };

  $scope.updateItem = function(data, id) {
    angular.extend(data, {id: id});
    var upsertReq = { 'type': "category", 'action' : "upsert", 'data' : data };
    var request = FactoryRequest.makeRequest("items",upsertReq,true); 
    var promise = FactoryBullet.send(request);
    // This is needed to display the loading dialog
    $scope.promiseCategories = promise;
    promise.then(function(response) {
      if (response.operation === "items") {
        if (response.data.result == "ok") {
          $scope.fetchCategories();
          console.log('Category Modified ',response.data);
        } else {
          console.log('Could not modify ',response.data);
          $scope.itemsMessage = response.data.msg;
	  $scope.items = [];
        }
      } else {
        console.log('Invalid response: ',response);
      }
    });
  };


  $scope.addItem = function() {
    if ($scope.formAddItem.$valid) {
      var addReq = { 'type': "category", 'action' : "add", 'data' : $scope.newItem };
      var request = FactoryRequest.makeRequest("items",addReq,true); 
      var promise = FactoryBullet.send(request);
      console.log("Submitting new Category: ",addReq);
      $scope.promiseCategories = promise;
      promise.then(function(response) {
        if (response.operation === "items") {
          if (response.data.result == "ok") {
	    $scope.formAddItem.$setPristine();
	    $scope.newItem = { name: "", description: ""};
            $scope.showAddItemPanel = false; 
            console.log('New Category added ',response.data);
            $scope.fetchItems();
          } else {
            console.log('Could not add new category ',response.data);
            $scope.itemsMessage = response.data.msg;
	    $scope.items = [];
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


