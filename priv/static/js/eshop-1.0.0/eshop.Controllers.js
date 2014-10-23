
var eshopControllers = angular.module('eshop.Controllers', []);

//---------------------- ControllerLanding ------------------------

eshopControllers.controller('ControllerLanding', ['$scope','FactoryUser',
  function($scope, FactoryUser) { 
 
  $scope.currentUser = FactoryUser.authenticate({ 'operation': "initialize" });

  $scope.$watch(function() {return FactoryUser.loginPromise},function() {
    $scope.promiseLogin = FactoryUser.loginPromise;
  });

  // Initialize the toggler object  
  $scope.toggler = {
    'showShop':true
    ,'showLogin':false
    ,'showBasket':false
    ,'showPersonal':false
  };


  // Mutate the toggler object in accordance to user role 
  $scope.$watch(function() {return FactoryUser.user},function() {
    $scope.currentUser = FactoryUser.user;
    if ($scope.currentUser.isLogged) {
      if($scope.currentUser.role === "admin") {
	$scope.toggler.showAdmin = false;
        $scope.toggler.showQueue = false;
      } else if ($scope.currentUser.role === "staff") {
        $scope.toggler.showQueue = false;
      } else {
      }
      $scope.visible('showShop');
    } else {
      $scope.toggler.showRegister = false;
      $scope.visible('showShop');
    }
  }),

  $scope.logout = function() {
    FactoryUser.logout();
    $scope.visible('showShop');
  };


//  $scope.switchVisible = function(viewKey,togglerVar) {
//    for (var key in togglerVar) {
//      console.log('View, var, key',[viewKey,togglerVar,key]);
//      // if the toggler has the key
//      if (togglerVar.hasOwnProperty(key)) {
//        // and the key is not an object
//        if (typeof(togglerVar[key]) !== 'object') {
//	  // if the key is not like the viewKey
//	  if (key !== viewKey) {
//            // make sure its value is false 
//            if(togglerVar[key] == true) {
//	      togglerVar[key] = false;
//	    }
//	  // otherwise set it to true
//	  } else {
//	    togglerVar[key] = true;
//	  }
//        // if it is 
//        } else {
//	  switchVisiable(viewKey,togglerVar[key]);
//        }
//      // if not do nothing
//      } else {
//      }
//    }  
//  };
//
//
//  $scope.visible = function(key) {
//    switchVisible(key,$scope.toggler);
//  };
//
  $scope.visible = function(view) {
    for (var key in $scope.toggler) {
      if ($scope.toggler.hasOwnProperty(key)) {
        if (key !== view) {
	  if ($scope.toggler[key] == true) {
	    $scope.toggler[key] = false;
          }
        } else {
	  $scope.toggler[key] = true;
	}
      }
    }
  };

}]);

//------------------------ ControllerShop ------------------------

eshopControllers.controller('ControllerShop', ['$scope','FactoryUser',
  'FactoryAlert','FactoryRequest',function($scope,FactoryUser
  ,FactoryAlert,FactoryRequest) {
  
//  $scope.toggler = $scope.$parent.toggler;

//  $scope.$watch('toggler',function() {
//    console.log($scope.toggler);
//  },true);

}]);
 

//------------------------ ControllerLogin ------------------------

eshopControllers.controller('ControllerLogin', ['$scope','FactoryUser',
  'FactoryAlert','FactoryRequest',function($scope,FactoryUser
  ,FactoryAlert,FactoryRequest) {
  $scope.login = {};
  $scope.alerts = [];

  $scope.closeAlert = function(index) {
    $scope.alerts.splice(index, 1);
  }
 
  $scope.$on("login:error",function(event,msg) {
    handleError(msg);
  });
  $scope.$on("login:timeout",function(event,msg) {
    handleError(msg);
  });
 
  function handleError(msg) {
     while($scope.alerts.length > 0) {
      $scope.alerts.pop();
    }
    $scope.alerts.push(FactoryAlert.makeAlert("danger",msg));  
  };

  $scope.$on("login:success",function(event,msg) {
    $scope.visible('showShop');
  });

  try {
    $scope.submit = function () {
      if ($scope.loginForm.$valid) {
        var loginReq = { 'type': "user", 'action' : "authenticate", 'data' : $scope.login };
        var request = FactoryRequest.makeRequest("login",loginReq,false); 
        FactoryUser.authenticate(request);
        $scope.login = {};
        $scope.loginForm.$setPristine();
      }
    };
  } catch(e) {
    console.log(e);
  }
  
}]);


//------------------------ ControllerRegister ------------------------

eshopControllers.controller('ControllerRegister', ['$scope','$timeout'
  ,'FactoryAlert','FactoryBullet', 
    function($scope, $timeout, FactoryAlert, FactoryBullet) {

  $scope.alerts = [
    { 'type': 'info', 'msg': 'Please fill in all form elements.' }
  ];

  $scope.pushAlerts = function() {
    var msg = null;
    if ($scope.signUpForm.fname.$invalid && $scope.signUpForm.fname.$dirty 
	&& !$scope.signUpForm.fname.$focused) {
      msg = FactoryAlert.makeAlert("error","First name is required");
    } 
    if ($scope.signUpForm.lname.$invalid && $scope.signUpForm.lname.$dirty 
	&& !$scope.signUpForm.lname.$focused) {
      msg = FactoryAlert.makeAlert("error","Last name is required");
    }
    if ($scope.signUpForm.addressline1.$invalid && $scope.signUpForm.addressline1.$dirty 
	&& !$scope.signUpForm.addressline1.$focused) {
      msg = FactoryAlert.makeAlert("error","Address Line 1 is required");
    }
    if ($scope.signUpForm.addressline2.$invalid && $scope.signUpForm.addressline2.$dirty 
	&& !$scope.signUpForm.addressline2.$focused) {
      msg = FactoryAlert.makeAlert("error","Address Line 2 is required");
    } 
    if ($scope.signUpForm.postcode.$invalid && $scope.signUpForm.postcode.$dirty 
	&& !$scope.signUpForm.postcode.$focused) {
      msg = FactoryAlert.makeAlert("error","Postcode is required");
    }
    if ($scope.signUpForm.city.$invalid && $scope.signUpForm.city.$dirty 
	&& !$scope.signUpForm.city.$focused) {
      msg = FactoryAlert.makeAlert("error","City / Town is required"); 
    }
    if ($scope.signUpForm.email.$invalid && $scope.signUpForm.email.$dirty 
	&& !$scope.signUpForm.email.$focused) {
      msg = FactoryAlert.makeAlert("error","Email is required");
    }
    if ($scope.signUpForm.password.$invalid && $scope.signUpForm.password.$dirty 
	&& !$scope.signUpForm.password.$focused) {
      msg = FactoryAlert.makeAlert("error","Password is required");
    }
    if ($scope.signUpForm.confirm_password.$invalid && $scope.signUpForm.confirm_password.$dirty 
	&& !$scope.signUpForm.confirm_password.$focused) {
      if (!$scope.signUpForm.confirm_password.$error.passwordVerify) {
        msg = FactoryAlert.makeAlert("error","Passwords do not match!");
      }
    }
    if ($scope.signUpForm.confirm_password.$valid && !$scope.signUpForm.confirm_password.$error.passwordVerify) {
      msg = FactoryAlert.makeAlert("error","Please confirm password!");
    } 
    if ($scope.signUpForm.$valid) {
       msg = FactoryAlert.makeAlert("success","Please submit the form.");
    }   
    $scope.pushAlert(msg,true);
  };

  $scope.pushAlert = function(alert,expire) {
    var timeout = 3000;
    if (alert != null) {
      while($scope.alerts.length > 0) {
        $scope.alerts.pop();
      }
      $scope.alerts.push(alert);
    }
    if (expire) {
      $timeout(function(){
        $scope.closeAlert($scope.alerts.indexOf(alert));
       }, timeout);
     }
  };

  $scope.closeAlert = function(index) {
    $scope.alerts.splice(index, 1);
    if ($scope.signUpForm.$valid) {
      $scope.alerts.push(FactoryAlert.makeAlert("success","Please submit the form."));
    } else {
      $scope.alerts.push(FactoryAlert.makeAlert("info","Please fill in all form elements."));
    }
  };

  $scope.submit = function () {
    if ($scope.signUpForm.$valid) {
      console.log($scope.newUser);
      console.log($scope.newAddress);
      console.log($scope.newShopper);
      var requestNewUser = { 'type' : "user" , 'data' : $scope.newUser }; 
      var requestNewAddress = { 'type' : "shopper_address" , 'data' : $scope.newAddress }; 
      var requestNewShopper = { 'type' : "shopper" , 'data' : $scope.newShopper }; 
      var request = { 'operation' : "register" , 'data' : [requestNewUser,requestNewAddress,requestNewShopper] };
      console.log("REQUEST IS:",request);
      var promise = FactoryBullet.send(request);
      $scope.pushAlert(FactoryAlert.makeAlert("success","Thank you."),false); 
      $scope.newUser = {'gender': "f"};
      $scope.signUpForm.$setPristine(); 
      promise.then(function(response) {
        console.log("resp ",response);
        if (response.operation !== "register") { 
          $scope.pushAlert(FactoryAlert.makeAlert("danger","There was an error. Try again later"),false);
        } else {
          $scope.visible('showLoginView');
        } 
      });
    }
  };
}]);




