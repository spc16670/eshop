
var eshopControllers = angular.module('eshop.controllers', []);

eshopControllers.config(function($interpolateProvider){
  $interpolateProvider.startSymbol('{[').endSymbol(']}');
});

//--------------------------- mainController ---------------------------

eshopControllers.controller('MainController', ['$scope','UserFactory',
  function($scope, UserFactory) { 
 
  $scope.currentUser = UserFactory.authenticate({ 'operation': "initialize"});

  $scope.$watch(function() {return UserFactory.loginPromise},function() {
    $scope.promiseLogin = UserFactory.loginPromise;
  }),

  $scope.$watch(function() {return UserFactory.user},function() {
    $scope.currentUser = UserFactory.user;
    if ($scope.currentUser.isLogged) {
      $scope.visible('showShoppingView');
    } else {
      $scope.visible('showLoginView');
    }
  }),

  $scope.logout = function() {
    UserFactory.logout();
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

eshopControllers.controller('ShopController', ['$scope','BulletFactory',
  'RequestFactory',function($scope,BulletFactory,RequestFactory) {
  $scope.categoriesMessage = "Fetching categories...";
  $scope.categories = []; 
  $scope.newCategory = { name: "", description: ""}; 
  
  $scope.send = function(data) {
    var promise = BulletFactory.send(data);
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

  $scope.inputValid = function(data, id) {
    if (data === "" || data == undefined) {
      return "Input cannot be empty";
    }
  };

  $scope.fetchCategories = function() {
    var categoriesShown = $scope.shopToggler.showEmenuCategories;
    if (categoriesShown == true) {
      // Refresh categories list
      $scope.categories = [];
      var fetchReq = { 'type': "category", 'action' : "fetch" };
      var request = RequestFactory.makeRequest("categories",fetchReq,true); 
      var promise = BulletFactory.send(request);
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

  $scope.removeCategory = function(index) {
    var removeCat = $scope.categories[index].data; 
    var deleteReq = { 'type': "category", 'action' : "delete", 'data' : removeCat };
    var request = RequestFactory.makeRequest("categories",deleteReq,true); 
    var promise = BulletFactory.send(request);
    console.log("Deleting Category: ",removeCat);
    // This is needed to display the loading dialog
    $scope.promiseCategories = promise;
    promise.then(function(response) {
      if (response.operation === "categories") {
        if (response.data.result == "ok") {
          $scope.fetchCategories();
          console.log('Category Modified ',response.data.msg);
        } else {
          console.log('Could not modify ',response.data.msg);
          $scope.categoriesMessage = response.data.msg;
          $scope.categories = [];
        }
      } else {
        console.log('Invalid response: ',response);
      }
    });
  };

  $scope.updateCategory = function(data, id) {
    angular.extend(data, {id: id});
    var upsertReq = { 'type': "category", 'action' : "upsert", 'data' : data };
    var request = RequestFactory.makeRequest("categories",upsertReq,true); 
    var promise = BulletFactory.send(request);
    // This is needed to display the loading dialog
    $scope.promiseCategories = promise;
    promise.then(function(response) {
      if (response.operation === "categories") {
        if (response.data.result == "ok") {
          $scope.fetchCategories();
          console.log('Category Modified ',response.data);
        } else {
          console.log('Could not modify ',response.data);
          $scope.categoriesMessage = response.data.msg;
	  $scope.categories = [];
        }
      } else {
        console.log('Invalid response: ',response);
      }
    });
  };


  $scope.addCategory = function() {
    if ($scope.formAddCategory.$valid) {
      var addReq = { 'type': "category", 'action' : "add", 'data' : $scope.newCategory };
      var request = RequestFactory.makeRequest("categories",addReq,true); 
      var promise = BulletFactory.send(request);
      console.log("Submitting new Category: ",addReq);
      $scope.promiseCategories = promise;
      promise.then(function(response) {
        if (response.operation === "categories") {
          if (response.data.result == "ok") {
	    $scope.formAddCategory.$setPristine();
	    $scope.newCategory = { name: "", description: ""};
            $scope.showAddCategoryItemPanel = false; 
            console.log('New Category added ',response.data);
            $scope.fetchCategories();
          } else {
            console.log('Could not add new category ',response.data);
            $scope.categoriesMessage = response.data.msg;
	    $scope.categories = [];
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

eshopControllers.controller('FormLoginController', ['$scope','UserFactory',
  'AlertFactory','RequestFactory',function($scope,UserFactory,AlertFactory,RequestFactory) {
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
    $scope.alerts.push(AlertFactory.makeAlert("danger",msg));  
  };

  $scope.$on("login:success",function(event,msg) {
    $scope.visible('showShoppingView');
  });

  try {
    $scope.submit = function () {
      if ($scope.loginForm.$valid) {
        var loginReq = { 'type': "user", 'action' : "authenticate", 'data' : $scope.login };
        var request = RequestFactory.makeRequest("login",loginReq,false); 
        UserFactory.authenticate(request);
        $scope.login = {};
        $scope.loginForm.$setPristine();
      }
    };
  } catch(e) {
    console.log(e);
  }
  
}]);


//------------------------ formSignUpController ------------------------

eshopControllers.controller('FormSignUpController', ['$scope','$timeout'
  ,'AlertFactory','BulletFactory', 
    function($scope, $timeout, AlertFactory, BulletFactory) {

  $scope.alerts = [
    { 'type': 'info', 'msg': 'Please fill in all form elements.' }
  ];

  $scope.pushAlerts = function() {
    var msg = null;
    if ($scope.signUpForm.fname.$invalid && $scope.signUpForm.fname.$dirty 
	&& !$scope.signUpForm.fname.$focused) {
      msg = AlertFactory.makeAlert("error","First name is required");
    } 
    if ($scope.signUpForm.lname.$invalid && $scope.signUpForm.lname.$dirty 
	&& !$scope.signUpForm.lname.$focused) {
      msg = AlertFactory.makeAlert("error","Last name is required");
    }
    if ($scope.signUpForm.addressline1.$invalid && $scope.signUpForm.addressline1.$dirty 
	&& !$scope.signUpForm.addressline1.$focused) {
      msg = AlertFactory.makeAlert("error","Address Line 1 is required");
    }
    if ($scope.signUpForm.addressline2.$invalid && $scope.signUpForm.addressline2.$dirty 
	&& !$scope.signUpForm.addressline2.$focused) {
      msg = AlertFactory.makeAlert("error","Address Line 2 is required");
    } 
    if ($scope.signUpForm.postcode.$invalid && $scope.signUpForm.postcode.$dirty 
	&& !$scope.signUpForm.postcode.$focused) {
      msg = AlertFactory.makeAlert("error","Postcode is required");
    }
    if ($scope.signUpForm.city.$invalid && $scope.signUpForm.city.$dirty 
	&& !$scope.signUpForm.city.$focused) {
      msg = AlertFactory.makeAlert("error","City / Town is required"); 
    }
    if ($scope.signUpForm.email.$invalid && $scope.signUpForm.email.$dirty 
	&& !$scope.signUpForm.email.$focused) {
      msg = AlertFactory.makeAlert("error","Email is required");
    }
    if ($scope.signUpForm.password.$invalid && $scope.signUpForm.password.$dirty 
	&& !$scope.signUpForm.password.$focused) {
      msg = AlertFactory.makeAlert("error","Password is required");
    }
    if ($scope.signUpForm.confirm_password.$invalid && $scope.signUpForm.confirm_password.$dirty 
	&& !$scope.signUpForm.confirm_password.$focused) {
      if (!$scope.signUpForm.confirm_password.$error.passwordVerify) {
        msg = AlertFactory.makeAlert("error","Passwords do not match!");
      }
    }
    if ($scope.signUpForm.confirm_password.$valid && !$scope.signUpForm.confirm_password.$error.passwordVerify) {
      msg = AlertFactory.makeAlert("error","Please confirm password!");
    } 
    if ($scope.signUpForm.$valid) {
       msg = AlertFactory.makeAlert("success","Please submit the form.");
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
      $scope.alerts.push(AlertFactory.makeAlert("success","Please submit the form."));
    } else {
      $scope.alerts.push(AlertFactory.makeAlert("info","Please fill in all form elements."));
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
      var promise = BulletFactory.send(request);
      $scope.pushAlert(AlertFactory.makeAlert("success","Thank you."),false); 
      $scope.newUser = {'gender': "f"};
      $scope.signUpForm.$setPristine(); 
      promise.then(function(response) {
        console.log("resp ",response);
        if (response.operation !== "register") { 
          $scope.pushAlert(AlertFactory.makeAlert("danger","There was an error. Try again later"),false);
        } else {
          $scope.visible('showLoginView');
        } 
      });
    }
  };
}]);




