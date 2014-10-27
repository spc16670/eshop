'use strict';

var eshopFactories = angular.module('eshop.admin.categories.Factories',[]);

eshopFactories.factory('FactoryCategories', ['FactoryRequest','FactoryBullet', 
  function(FactoryRequest,FactoryBullet) {  
  
  var Service = {
    state : 0
    ,categories : []
    ,message : ""
    ,promise : null
  };

  Service.fetchCategories = function() {
    Service.state = 1;
    var fetchReq = { 'type': "category", 'action' : "fetch" };
    var request = FactoryRequest.makeRequest("categories",fetchReq,true);
    var promise = FactoryBullet.send(request);
    Service.promise = promise;
    promise.then(function(response) {
      console.log('Response',response);
      if (response.operation === "categories") {
	if (response.data.result == "ok") {
	  Service.message = response.data.msg;
	  Service.categories = response.data.data;
          Service.state = 2;
	} else if(response.data.result == "error") {
	  Service.message = response.data.msg;
          console.log('service msg: ',Service.message);
          Service.categories = [];
          Service.state = 4;
	} else {
	  Service.message = response.data.msg;
	  Service.categories = [];
          Service.state = 5;
        };
        console.log('Category: ',response.data);
      } else {
        Service.message = "Invalid response";
	Service.categories = [];
        console.log('Invalid response: ',response);
        Service.state = 6;
      }
    });
  };

  Service.removeCategory = function(index) {
    Service.state = 11;
    var removeCat = Service.categories[index].data; 
    var deleteReq = { 'type': "category", 'action' : "delete", 'data' : removeCat };
    var request = FactoryRequest.makeRequest("categories",deleteReq,true); 
    var promise = FactoryBullet.send(request);
    console.log("Deleting Category: ",removeCat);
    Service.promise = promise;
    promise.then(function(response) {
      if (response.operation === "categories") {
        if (response.data.result == "ok") {
          Service.fetchCategories();
          console.log('Category Modified ',response.data.msg);
        } else {
          console.log('Could not delete',response);
          Service.message = response.data.msg;
          Service.categories = [];
          Service.state = 12;
        }
      } else {
        console.log('Invalid response: ',response);
        Service.state = 13;
      }
    });
  };

  Service.updateCategory = function(data,id) {
    Service.state = 21;
    angular.extend(data, {id: id});
    var upsertReq = { 'type': "category", 'action' : "upsert", 'data' : data };
    var request = FactoryRequest.makeRequest("categories",upsertReq,true); 
    var promise = FactoryBullet.send(request);
    // This is needed to display the loading dialog
    Service.promise = promise;
    promise.then(function(response) {
      if (response.operation === "categories") {
        if (response.data.result == "ok") {
          Service.fetchCategories();
          console.log('Category Modified ',response.data);
        } else {
          console.log('Could not modify ',response.data);
          Service.message = response.data.msg;
	  Service.categories = [];
          Service.state = 22;
        }
      } else {
        console.log('Invalid response: ',response);
        Service.state = 23;
      }
    });
  };

  Service.addCategory = function(newCat) {
    Service.state = 31;
    Service.categories = null;
    var addReq = { 'type': "category", 'action' : "add", 'data' : newCat };
    var request = FactoryRequest.makeRequest("categories",addReq,true); 
    var promise = FactoryBullet.send(request);
    console.log("Submitting new Category: ",addReq);
    Service.promise = promise;
    promise.then(function(response) {
      if (response.operation === "categories") {
        if (response.data.result == "ok") {
          console.log('New Category added ',response.data);
          Service.fetchCategories();
        } else {
          console.log('Could not add new category ',response.data);
          Service.message = response.data.msg;
	  Service.categories = [];
          Service.state = 32;
        }
      } else {
        console.log('Invalid response: ',response);
        Service.state = 33;
      }
    }); 
  };

  return Service; 
}]);
