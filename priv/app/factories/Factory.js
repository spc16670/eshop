'use strict';

var eshopFactories = angular.module('eshop.Factory',[]);

eshopFactories.factory('FactoryBullet', ['$q','$timeout','$rootScope', 
  function($q,$timeout,$rootScope) {  
  var Service = { promise: null, cid : 0 };
  var sid = document.getElementById('session_id');
  var hostname = document.getElementById('hostname');
  var clientTimeout = document.getElementById('client_timeout').textContent;
  var clientTimeout = parseInt(clientTimeout);
  var url = 'wss://' + hostname.textContent  + ':8443/bullet/' + sid.textContent;
  var options = { 'disableEventSource': true, 'disableXHRPolling' : true};
  //var options = {};
  var bullet = $.bullet(url, options);
  var callbacks = {};
  var currentCallbackId = 0;

  var isOpened = false;
  var scheduledQueue = [];

  bullet.onopen = function(){
    isOpened = true;
    for (var i = 0; i < scheduledQueue.length; i++) {
      console.log("DEQUEUING REQUESTS",scheduledQueue);
      fireBullet(scheduledQueue[i]);
      scheduledQueue.splice(i,1);
    }
    console.log("CONNECTION OPENED: ",bullet);
  };

  bullet.onclose = bullet.ondisconnect = function(){
    console.log('CONNECTION CLOSED');
    isOpened = false;
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
    Service.cid = callbackId; 
    request.cbid = callbackId;
    var timeoutPromise = $timeout(function(data){
      var timeoutRequest = request;
      timeoutRequest.cbid = callbackId;
      timeoutRequest.data.result = "timeout";
      timeoutRequest.data.msg = "A timeout occurred";
      console.log('TIMEOUT',timeoutRequest);
      listener(timeoutRequest);
    },clientTimeout);

    callbacks[callbackId] = {
      time: new Date(),
      cb: defer,
      timeoutPromise: timeoutPromise
    };
    // This will prevent the 'still in CONNECTING' state error 
    if (isOpened) {
      fireBullet(request);
    } else {
      scheduledQueue.push(request);
    }
    return defer.promise;
  }

  function fireBullet(request) {
    bullet.send(JSON.stringify(request));
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
    Service.promise = promise; 
    return promise;
  }
  return Service; 
}]);

// ------------------------- userService ------------------------------

eshopFactories.factory('FactoryAuth', ['FactoryBullet','FactoryStorage'
  ,'$rootScope',function(FactoryBullet,FactoryStorage,$rootScope) {
  var storageKey = "user";
  var UserService = {};
  
  var loggedOutState = { 
    'isLogged': false
    , 'access': 1
    , 'token': null
    , 'msg': "Logged out"
    , 'attempt': "ok"
  };
    
  UserService.user = loggedOutState;
  UserService.promise = null;
 
  UserService.authenticate = function(loginReq) {
    if (loginReq.operation === "login") {
      var promiseLogin = FactoryBullet.send(loginReq);
      UserService.promise = promiseLogin;
      promiseLogin.then(function(response){
        var data = response.data;
        if (data.result === "ok") { 
	  // iterate object in data key and retrieve user and shopper
	  for (var obj in data.data) {
            var interatedObj = data.data[obj];
	    if (interatedObj.type === "user") {
	      UserService.user.email = interatedObj.data.email;
	      UserService.user.access = interatedObj.data.access;
	    } else if (interatedObj.type === "shopper") {
	      UserService.user.shopper = interatedObj.data;
	    }
 	  }
	  UserService.user.token = data.token; 
	  UserService.user.msg = "Logged In"; 
          UserService.user.attempt = "ok"
	  UserService.user.isLogged = true; 
	  // persist user
          FactoryStorage.persist(storageKey,UserService.user);
	  console.log("USER IS:",UserService.user);
        } else if (data.result === "timeout") { 
 	  UserService.logout();
          UserService.user.msg = "Request timed out"
          UserService.user.attempt = "timeout"
        } else if (data.result === "error") {
 	  UserService.logout();
          UserService.user.attempt = "error"
          UserService.user.msg = "There was an error"
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
    console.log('LOGGING OUT');
    UserService.user = {
      'isLogged': false
      , 'access': 1
      , 'token': null
      , 'msg': "Logged out"
      , 'attempt': "ok"
    };
    // watch does not intercept the change below
    //UserService.user = loggedOutState;
    FactoryStorage.remove(storageKey);
  };
  
  return UserService;
}]);

// ------------------------- FactoryStorage ------------------------------

eshopFactories.factory('FactoryPartials', ['FactoryRequest','FactoryBullet',
  function(FactoryRequest,FactoryBullet) {

  var Service = {
    state : 0
    ,partial : []
    ,message : ""
    ,promise : null
  };

  Service.fetch = function(name) {
    console.log('FactoryPartials',name);
    Service.state = 1;
    var fetchReq = { 'type': name, 'action' : "fetch" };
    var request = FactoryRequest.makeRequest("partials",fetchReq,false);
    var promise = FactoryBullet.send(request);
    Service.promise = promise;
    promise.then(function(response) {
      if (response.operation === "partials") {
        console.log('FactoryPartials response:',response);
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

eshopFactories.factory('FactoryRequest', ['FactoryAuth',
  function(FactoryAuth) {
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
        requestObj.token = FactoryAuth.user.token;
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


