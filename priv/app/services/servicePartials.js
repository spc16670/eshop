'use strict';

var eshopFactories = angular.module('servicePartials',[]);

eshopFactories.factory('ServicePartials', ['FactoryRequest','FactoryBullet', 
  function(FactoryRequest,FactoryBullet) {  
  
  var Service = {
    state : 0
    ,partial : []
    ,message : ""
    ,promise : null
  };

  Service.fetch = function(name) {
    Service.state = 1;
    var fetchReq = { 'type': name, 'action' : "fetch" };
    var request = FactoryRequest.makeRequest("partials",fetchReq,false);
    var promise = FactoryBullet.send(request);
    Service.promise = promise;
    promise.then(function(response) {
      if (response.operation === "partials") {
        console.log('ServicePartials response:',response);
	if (response.data.result == "ok") {
	  Service.message = response.data.msg;
	  Service.partial = response.data.partial;
          Service.state = 2;
	} else if(response.data.result == "error") {
	  Service.message = response.data.msg;
          console.log('service msg: ',Service.message);
          Service.partial = response.data.msg;
          Service.state = 4;
	} else {
	  Service.message = response.data.msg;
          Service.partial = response.data.msg;
          Service.state = 5;
        };
      } else {
        Service.message = "Invalid response";
        Service.partial = response.data.msg;
        console.log('Invalid response: ',response);
        Service.state = 6;
      }
    });
  };

  return Service; 
}]);
