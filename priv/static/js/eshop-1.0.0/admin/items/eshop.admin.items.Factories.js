'use strict';

var eshopFactories = angular.module('eshop.admin.items.Factories',[]);

eshopFactories.factory('FactoryItems', ['FactoryRequest','FactoryBullet', 
  function(FactoryRequest,FactoryBullet) {  
  
  var Service = {
    state : 0
    ,items : []
    ,count : 0
    ,offset : 0
    ,limit : 50
    ,message : ""
    ,promise : null
  };

  Service.fetchItems = function(offset,limit,category_id) {
    Service.state = 1;
    var fetchReq = { 
      'type': "items"
      , 'action' : "fetch"
      , 'offset' : offset
      , 'limit' : limit
      , 'category_id' : category_id };
    var request = FactoryRequest.makeRequest("items",fetchReq,true);
    var promise = FactoryBullet.send(request);
    Service.promise = promise;
    promise.then(function(response) {
      console.log('Response',response);
      if (response.operation === "items") {
	if (response.data.result == "ok") {
	  Service.offset = offset;
	  Service.limit = limit;
	  Service.count = response.data.count;
	  Service.message = response.data.msg;
	  Service.items = response.data.data;
          Service.state = 2;
	} else if(response.data.result == "error") {
	  Service.message = response.data.msg;
          console.log('service msg: ',Service.message);
          Service.items = [];
          Service.state = 4;
	} else {
	  Service.message = response.data.msg;
	  Service.items = [];
          Service.state = 5;
        };
        console.log('Items: ',response.data);
      } else {
        Service.message = "Invalid response";
	Service.items = [];
        console.log('Invalid response: ',response);
        Service.state = 6;
      }
    });
  };

  Service.removeItem = function(index) {
    Service.state = 11;
    var removeCat = Service.index[index].data; 
    var deleteReq = { 'type': "item", 'action' : "delete", 'data' : removeCat };
    var request = FactoryRequest.makeRequest("items",deleteReq,true); 
    var promise = FactoryBullet.send(request);
    console.log("Deleting Item: ",removeCat);
    Service.promise = promise;
    promise.then(function(response) {
      if (response.operation === "items") {
        if (response.data.result == "ok") {
          Service.fetchItems(Service.offset,Service.limit);
          console.log('Item Modified ',response.data.msg);
        } else {
          console.log('Could not delete',response);
          Service.message = response.data.msg;
          Service.items = [];
          Service.state = 12;
        }
      } else {
        console.log('Invalid response: ',response);
        Service.state = 13;
      }
    });
  };

  Service.updateItem = function(data,id) {
    Service.state = 21;
    angular.extend(data, {id: id});
    var upsertReq = { 'type': "item", 'action' : "upsert", 'data' : data };
    var request = FactoryRequest.makeRequest("items",upsertReq,true); 
    var promise = FactoryBullet.send(request);
    // This is needed to display the loading dialog
    Service.promise = promise;
    promise.then(function(response) {
      if (response.operation === "items") {
        if (response.data.result == "ok") {
          Service.fetchItems(Service.offset,Service.limit);
          console.log('Item Modified ',response.data);
        } else {
          console.log('Could not modify ',response.data);
          Service.message = response.data.msg;
	  Service.items = [];
          Service.state = 22;
        }
      } else {
        console.log('Invalid response: ',response);
        Service.state = 23;
      }
    });
  };

  Service.addItem = function(newItem) {
    Service.state = 31;
    var addReq = { 'type': "item", 'action' : "add", 'data' : newItem };
    var request = FactoryRequest.makeRequest("items",addReq,true); 
    var promise = FactoryBullet.send(request);
    console.log("Submitting new Item: ",addReq);
    Service.promise = promise;
    promise.then(function(response) {
      if (response.operation === "items") {
        if (response.data.result == "ok") {
          console.log('New Item added ',response.data);
          Service.fetchItems(Service.offset,Service.limit);
        } else {
          console.log('Could not add new category ',response.data);
          Service.message = response.data.msg;
	  Service.items = [];
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
