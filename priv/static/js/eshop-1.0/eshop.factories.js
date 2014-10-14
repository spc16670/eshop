'use strict';

var eshopFactories = angular.module('eshopFactories',[]);

eshopFactories.factory('bulletFactory', ['$q','$rootScope', function($q,$rootScope) {  
  var Service = {};
  var sid = document.getElementById('session_id');
  var hostname = document.getElementById('hostname');
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
    callbacks[callbackId] = {
      time: new Date(),
      cb: defer
    };
    request.cbid = callbackId;
    bullet.send(JSON.stringify(request));
    return defer.promise;
  }

  function listener(data) {
    var messageObj = data;
    // If an object exists with cbid in our callbacks object, resolve it
    if(callbacks.hasOwnProperty(messageObj.cbid)) {
      $rootScope.$apply(callbacks[messageObj.cbid].cb.resolve(messageObj));
      delete callbacks[messageObj.callbackID];
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

eshopFactories.factory('userFactory', ['bulletFactory','storageFactory'
  ,'$rootScope',function(bulletFactory,storageFactory,$rootScope) {
  var UserService = {};

  UserService.user = {};
    
  UserService.authenticate = function(loginReq) {
    if (loginReq.type === "login") {
      var promise = bulletFactory.send(loginReq);
      promise.then(function(response){
        var data = response.data;
        if (data.result === "ok") { 
	  // iterate object in data key and retrieve user and shopper
	  for (var obj in data.data) {
            var interatedObj = data.data[obj]
	    if (interatedObj.type === "user") {
	      UserService.user['email'] = interatedObj.data.email;
	    } else if (interatedObj.type === "shopper") {
	        UserService.user['shopper'] = interatedObj.data;
	    }
 	  }
	  UserService.user['token'] = data.token; 
	  console.log("USER IS:",UserService.user),
	  UserService.user.isLogged = true; 
	  $rootScope.$broadcast("login:success","");
	  // persist user
          storageFactory.persist("user",UserService.user);
        } else if (data.result === "error") {
 	  UserService.user.isLogged = false;
	  $rootScope.$broadcast("login:error",data.msg);
        }
      });    
    } else if (loginReq.type === "initialize") {
      var returningUser = storageFactory.retrieve("user");
      if (returningUser) {
        UserService.user = returningUser;
      } else {
      }
    }
  };

  UserService.logout = function() {
    UserService.user = {};
    storageFactory.remove("user");
  };
  
  return UserService;
}]);


// ------------------------- storageFactory ------------------------------

eshopFactories.factory('storageFactory',['$window',function($window) {
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

// ------------------------- alertFactory ------------------------------

eshopFactories.factory('alertFactory', [function() {
  return {
    makeAlert: function(type,msg) {
      return {'type' : type, 'msg' : msg};
    }
  }
}]);


