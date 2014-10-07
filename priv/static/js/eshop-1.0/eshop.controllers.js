
var eshopControllers = angular.module('eshopControllers', []);

eshopControllers.config(function($interpolateProvider){
  $interpolateProvider.startSymbol('{[').endSymbol(']}');
});

//--------------------------- mainController ---------------------------

eshopControllers.controller('mainController', ['$scope','userFactory',
  function($scope, userFactory) { 
 
  $scope.currentUser = userFactory.authenticate({type: "initialize"});

  $scope.$watch(function() {return userFactory.user},function() {
    $scope.currentUser = userFactory.user;
    $scope.visible('showShoppingView');
  }),

  $scope.logout = function() {
    userFactory.logout();
  };

  // view display 
  $scope.toggler = {
    'showSignUpView':false
    ,'showShoppingView':true
    ,'showLoginView':false
    ,'showBasketView':false
    ,'showPersonalView':false
  };
 
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

//------------------------- formShopController ------------------------

eshopControllers.controller('shopController', ['$scope','bulletFactory',
  function($scope,bulletFactory) {
  $scope.message = '';
  $scope.messages = []; 
  
  $scope.send = function(data) {
    var promise = bulletFactory.send(data);
  };
}]);

//------------------------ formLoginController ------------------------

eshopControllers.controller('formLoginController', ['$scope','userFactory',
  'alertFactory',function($scope,userFactory,alertFactory) {
  $scope.login = {};
  $scope.alerts = [];

  $scope.closeAlert = function(index) {
    $scope.alerts.splice(index, 1);
  }
 
  $scope.$on("login:error",function(event,msg) {
    while($scope.alerts.length > 0) {
      $scope.alerts.pop();
    }
    $scope.alerts.push(alertFactory.makeAlert("danger",msg));
  });
  $scope.$on("login:success",function(event,msg) {
    $scope.visible('showShoppingView');
  });

  try {
    $scope.submit = function () {
      if ($scope.loginForm.$valid) {
        var user = { type : "user" , data : $scope.login };
        userFactory.authenticate({ type : "login", data : user});
        $scope.login = {};
        $scope.loginForm.$setPristine();
      }
    };
  } catch(e) {
    console.log(e);
  }
  
}]);


//------------------------ formSignUpController ------------------------

eshopControllers.controller('formSignUpController', ['$scope','$timeout'
  ,'alertFactory','bulletFactory', 
    function($scope, $timeout, alertFactory, bulletFactory) {

  $scope.alerts = [
    { 'type': 'info', 'msg': 'Please fill in all form elements.' }
  ];

  $scope.pushAlerts = function() {
    var msg = null;
    if ($scope.signUpForm.fname.$invalid && $scope.signUpForm.fname.$dirty 
	&& !$scope.signUpForm.fname.$focused) {
      msg = alertFactory.makeAlert("error","First name is required");
    } 
    if ($scope.signUpForm.lname.$invalid && $scope.signUpForm.lname.$dirty 
	&& !$scope.signUpForm.lname.$focused) {
      msg = alertFactory.makeAlert("error","Last name is required");
    }
    if ($scope.signUpForm.addressline1.$invalid && $scope.signUpForm.addressline1.$dirty 
	&& !$scope.signUpForm.addressline1.$focused) {
      msg = alertFactory.makeAlert("error","Address Line 1 is required");
    }
    if ($scope.signUpForm.addressline2.$invalid && $scope.signUpForm.addressline2.$dirty 
	&& !$scope.signUpForm.addressline2.$focused) {
      msg = alertFactory.makeAlert("error","Address Line 2 is required");
    } 
    if ($scope.signUpForm.postcode.$invalid && $scope.signUpForm.postcode.$dirty 
	&& !$scope.signUpForm.postcode.$focused) {
      msg = alertFactory.makeAlert("error","Postcode is required");
    }
    if ($scope.signUpForm.city.$invalid && $scope.signUpForm.city.$dirty 
	&& !$scope.signUpForm.city.$focused) {
      msg = alertFactory.makeAlert("error","City / Town is required"); 
    }
    if ($scope.signUpForm.email.$invalid && $scope.signUpForm.email.$dirty 
	&& !$scope.signUpForm.email.$focused) {
      msg = alertFactory.makeAlert("error","Email is required");
    }
    if ($scope.signUpForm.password.$invalid && $scope.signUpForm.password.$dirty 
	&& !$scope.signUpForm.password.$focused) {
      msg = alertFactory.makeAlert("error","Password is required");
    }
    if ($scope.signUpForm.confirm_password.$invalid && $scope.signUpForm.confirm_password.$dirty 
	&& !$scope.signUpForm.confirm_password.$focused) {
      if (!$scope.signUpForm.confirm_password.$error.passwordVerify) {
        msg = alertFactory.makeAlert("error","Passwords do not match!");
      }
    }
    if ($scope.signUpForm.confirm_password.$valid && !$scope.signUpForm.confirm_password.$error.passwordVerify) {
      msg = alertFactory.makeAlert("error","Please confirm password!");
    } 
    if ($scope.signUpForm.$valid) {
       msg = alertFactory.makeAlert("success","Please submit the form.");
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
      $scope.alerts.push(alertFactory.makeAlert("success","Please submit the form."));
    } else {
      $scope.alerts.push(alertFactory.makeAlert("info","Please fill in all form elements."));
    }
  };

  $scope.submit = function () {
    if ($scope.signUpForm.$valid) {
      console.log($scope.newUser);
      console.log($scope.newAddress);
      console.log($scope.newShopper);
      var requestNewUser = { 'type' : 'user' , 'data' : $scope.newUser }; 
      var requestNewAddress = { 'type' : 'shopper_address' , 'data' : $scope.newAddress }; 
      var requestNewShopper = { 'type' : 'shopper' , 'data' : $scope.newShopper }; 
      var request = { 'type' : 'register' , 'data' : [requestNewUser,requestNewAddress,requestNewShopper] };
      console.log("REQUEST IS:",request);
      var promise = bulletFactory.send(request);
      $scope.pushAlert(alertFactory.makeAlert("success","Thank you."),false); 
      $scope.newUser = {'gender': "f"};
      $scope.signUpForm.$setPristine(); 
      promise.then(function(response) {
        console.log("resp ",response);
        if (response.type !== "register") { 
          $scope.pushAlert(alertFactory.makeAlert("danger","There was an error. Try again later"),false);
        } else {
          $scope.visible('showLoginView');
        } 
      });
    }
  };
}]);




