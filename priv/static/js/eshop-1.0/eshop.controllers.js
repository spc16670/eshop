
var eshopControllers = angular.module('eshopControllers', []);

eshopControllers.config(function($interpolateProvider){
  $interpolateProvider.startSymbol('{[').endSymbol(']}');
});

//--------------------------- mainController ---------------------------

eshopControllers.controller('mainController', ['$scope','userFactory',
  function($scope, userFactory) { 
 
  $scope.currentUser = userFactory.authenticate({ 'operation': "initialize"});

  $scope.$watch(function() {return userFactory.loginPromise},function() {
    $scope.promiseLogin = userFactory.loginPromise;
  }),

  $scope.$watch(function() {return userFactory.user},function() {
    $scope.currentUser = userFactory.user;
    if ($scope.currentUser.isLogged) {
      $scope.visible('showShoppingView');
    } else {
      $scope.visible('showLoginView');
    }
  }),

  $scope.logout = function() {
    userFactory.logout();
    $scope.visible('showLoginView');
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
  '$rootScope',function($scope,bulletFactory,$rootScope) {
  $scope.categoriesMessage = "Fetching categories...";
  $scope.categories = []; 
  $scope.newCategory = { name: "", description: ""}; 
  
  $scope.send = function(data) {
    var promise = bulletFactory.send(data);
  };

  // view display 
  $scope.shopToggler = {
    'showEmenuStart':true
    ,'showEmenuLook':false
    ,'showEmenuCategories':false
    ,'showEmenuItems':false
    ,'showEmenuOffers':false
    ,'showEmenuResult':false
  };

  $scope.fetchCategories = function() {
    var categoriesShown = $scope.shopToggler.showEmenuCategories;
    if (categoriesShown == true) {
      // Refresh categories list
      $scope.categories = [];
      $scope.authenticated = false;
      // Fire bullet request for JSON and display an image until the
      // future object is resolved.
      //
      // Once the future object resolves fire a directive to display a
      // dynamically constructed table.
      //
      // {
      //   operation: "",
      //   data: {
      //     type: "",
      //     action: "",
      //     token: "",
      //     data: { },
      //   }
      // }
      //
      var token = $scope.currentUser.token;
      var fetchReq = { 'type': "category", 'action' : "fetch", 'token' : token };
      var promise = bulletFactory.send({ 'operation' : "categories", data : fetchReq });
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

  $scope.$watch('shopToggler',function() {
    $scope.fetchCategories();
  },true),

  $scope.shopVisible = function(view) {
    for (var key in $scope.shopToggler) {
      if ($scope.shopToggler.hasOwnProperty(key)) {
        if (key !== view) {
          if ($scope.shopToggler[key] == true) {
            $scope.shopToggler[key] = false;
          }
        } else {
          $scope.shopToggler[key] = true;
        }
      }
    }
  };

  $scope.handleCategory = function(obj) {
    console.log('handle: ',obj);
    var formName = "formHandleCategory-" + obj.obj.data.id;
    console.log("Handle Category Name: ",formName);
  };


  $scope.removeCategory = function(index) {
    $scope.categories.splice(index, 1);
  };


  $scope.addCategory = function() {
    if ($scope.formAddCategory.$valid) {
      
      // Call Out
      var token = $scope.currentUser.token;
      var addReq = { 'type' : "category", 'action' : "add", 'token' : token, 'data' : $scope.newCategory };

      console.log("Submitting new Category: ",addReq);
      var promise = bulletFactory.send({ 'operation' : "categories", 'data' : addReq });
      $scope.promiseCategories = promise;
      promise.then(function(response) {
        if (response.operation === "categories") {
          if (response.data.result == "ok") {
            $scope.fetchCategories();
	    $scope.formAddCategory.$setPristine();
	    $scope.newCategory = { name: "", description: ""};
            $scope.showAddCategoryItemPanel = false; 
            console.log('New Category added ',response.data);
          } else {
            console.log('Could not add new category ',response.data);
            $scope.categoriesMessage = response.data.msg;
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
        var request = { 'type' : "user", 'action' : "authenticate", 'data' : $scope.login };
        userFactory.authenticate({ 'operation' : "login", 'data' : request});
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
      var requestNewUser = { 'type' : "user" , 'data' : $scope.newUser }; 
      var requestNewAddress = { 'type' : "shopper_address" , 'data' : $scope.newAddress }; 
      var requestNewShopper = { 'type' : "shopper" , 'data' : $scope.newShopper }; 
      var request = { 'operation' : "register" , 'data' : [requestNewUser,requestNewAddress,requestNewShopper] };
      console.log("REQUEST IS:",request);
      var promise = bulletFactory.send(request);
      $scope.pushAlert(alertFactory.makeAlert("success","Thank you."),false); 
      $scope.newUser = {'gender': "f"};
      $scope.signUpForm.$setPristine(); 
      promise.then(function(response) {
        console.log("resp ",response);
        if (response.operation !== "register") { 
          $scope.pushAlert(alertFactory.makeAlert("danger","There was an error. Try again later"),false);
        } else {
          $scope.visible('showLoginView');
        } 
      });
    }
  };
}]);




