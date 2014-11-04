'use strict';

var eshopFactories = angular.module('eshop.Factories',[]);

eshopFactories.factory('FactoryBullet', ['$q','$timeout','$rootScope', 
  function($q,$timeout,$rootScope) {  
  var Service = {};
  var sid = document.getElementById('session_id');
  var hostname = document.getElementById('hostname');
  var clientTimeout = document.getElementById('client_timeout').textContent;
  var clientTimeout = parseInt(clientTimeout);
  var url = 'wss://' + hostname.textContent  + ':8443/bullet/' + sid.textContent;
  var options = {'disableWebSocket': true, 'disableEventSource': true};
  //var options = {};
  var bullet = $.bullet(url, options);
  var name = 'best';
  var callbacks = {};
  var currentCallbackId = 0;

  bullet.onopen = function(){
    console.log("Connection opened.");
  };
  bullet.onclose = bullet.ondisconnect = function(){
    console.log('CONNECTION CLOSED');
  };
  bullet.onmessage = function(e){
    if (e.data != 'pong'){
      listener($.parseJSON(e.data));
    }
  };
  bullet.onheartbeat = function(){
    console.log('HEARTBEAT');
  };

  function sendRequest(request) {
    var defer = $q.defer();
    var callbackId = getCallbackId();
    request.cbid = callbackId;
    var timeoutPromise = $timeout(function(data){
      var timeoutRequest = request;
      timeoutRequest.data.result = "timeout";
      timeoutRequest.data.msg = "A timeout occurred";
      listener(timeoutRequest);
    },clientTimeout);

    callbacks[callbackId] = {
      time: new Date(),
      cb: defer,
      timeoutPromise: timeoutPromise
    };
    
    bullet.send(JSON.stringify(request));
    return defer.promise;
  }

  function listener(data) {
    var messageObj = data;
    // If an object exists with cbid in our callbacks object, resolve it
    if(callbacks.hasOwnProperty(messageObj.cbid)) {
      var callback = callbacks[messageObj.cbid];
      $timeout.cancel(callback.timeoutPromise);
      $rootScope.$apply(callback.cb.resolve(messageObj));
      delete callbacks[messageObj.cbid];
    }
  }

  // This creates a new callback ID for a request
  function getCallbackId() {
    currentCallbackId += 1;
    if(currentCallbackId > 10000) {
      currentCallbackId = 0;
    }
    return currentCallbackId;
  }

  // Define a "getter" for getting customer data
  Service.send = function(msg) {
    msg.cbid = null;
    // Storing in a variable for clarity on what sendRequest returns
    var promise = sendRequest(msg); 
    return promise;
  }
  return Service; 
}]);

// ------------------------- userService ------------------------------

eshopFactories.factory('FactoryAuth', ['FactoryBullet','FactoryStorage'
  ,'$rootScope',function(FactoryBullet,FactoryStorage,$rootScope) {
  var UserService = { };

  UserService.user = { 'isLogged': false, 'access': 1, 'token': null };
    
  UserService.authenticate = function(loginReq) {
    if (loginReq.operation === "login") {
      var promiseLogin = FactoryBullet.send(loginReq);
      UserService.loginPromise = promiseLogin;
      promiseLogin.then(function(response){
        var data = response.data;
        if (data.result === "ok") { 
	  // iterate object in data key and retrieve user and shopper
	  for (var obj in data.data) {
            var interatedObj = data.data[obj];
	    if (interatedObj.type === "user") {
	      UserService.user['email'] = interatedObj.data.email;
	      UserService.user['access'] = interatedObj.data.role;
	    } else if (interatedObj.type === "shopper") {
	      UserService.user['shopper'] = interatedObj.data;
	    }
 	  }
	  UserService.user.token = data.token; 
	  console.log("USER IS:",UserService.user),
	  //$rootScope.$broadcast("login:success","");
	  // persist user
          FactoryStorage.persist("user",UserService.user);
	  UserService.user.isLogged = true; 
        } else if (data.result === "timeout") { 
 	  UserService.logout();
	  //$rootScope.$broadcast("login:timeout",data.msg);
        } else if (data.result === "error") {
 	  UserService.logout();
	  //$rootScope.$broadcast("login:error",data.msg);
        }
      });    
    } else if (loginReq.operation === "initialize") {
      var returningUser = FactoryStorage.retrieve("user");
      if (returningUser) {
        UserService.user = returningUser;
      } else {
      }
    }
  };

  UserService.logout = function() {
    UserService.user = { 'isLogged' : false, 'access': 1, 'token' : null };
    FactoryStorage.remove("user");
  };
  
  return UserService;
}]);


// ------------------------- FactoryStorage ------------------------------

eshopFactories.factory('FactoryStorage',['$window',function($window) {
  var StorageService = {};
  if ($window.localStorage) {

    StorageService = {
      persist : function(key,value) {
	  var obj = {'data': value, 'timestamp': new Date().getTime()};
          $window.localStorage.setItem(key,JSON.stringify(obj));
        },
      retrieve : function(key) {
          var str = $window.localStorage.getItem(key);
	  var val = {};
	  var timestamp = 0;
	  val = str ? JSON.parse(str) : null;
          if (val) {
	    var date = new Date();
	    var expires = date.setDate(date.getDate() - 2);
	    if (val.timestamp > expires) {
	      val = val.data;
	      StorageService.persist(key,val);
	      console.log('Item refreshed');
	    } else {
	      $window.localStorage.removeItem(key);
	      console.log('Expired item removed');
	    }
          }
	  return val;
        },
      remove : function(key) {
	  $window.localStorage.removeItem(key);
        },
      clear : function() {
	  $window.localStorage.clear();
	}
    };

  } else {
    console.log("LOCAL STORAGE IS NOT SUPPORTED");
  }
  
  return StorageService;
}]);

// ------------------------- callService ------------------------------

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


// ------------------------- callService ------------------------------

eshopFactories.factory('FactoryRequest', ['FactoryUser',
  function(FactoryUser) {
  // {
  //   cbid : 8 -- Callback id is temporarily added by the FactoryBullet
  //
  //   operation: "",
  //   data: {
  //     type: "",
  //     action: "",
  //     token: "",
  //     data: { },
  //   }
  // }

  return {
    makeRequest: function(operation,requestObj,authorised) {
      if (authorised == true) {
        requestObj.token = FactoryUser.user.token;
      };
      return {
        'operation' : operation, 
        'data' : requestObj
      };
    }
  }
}]);

// ------------------------- alertFactory ------------------------------

eshopFactories.factory('FactoryAlert', [function() {
  return {
    makeAlert: function(type,msg) {
      return {'type' : type, 'msg' : msg};
    }
  }
}]);


