
var eshopApp = angular.module('EShop', [
  'ngRoute'
  ,'ngAnimate'
  ,'ui.bootstrap'
  ,'ui.router'
  ,'xeditable'
  ,'cgBusy'
  ,'eshop.admin.categories.Controllers'
  ,'eshop.admin.categories.Factories'
  ,'eshop.admin.items.Controllers'
  ,'eshop.admin.items.Factories'
  ,'eshop.admin.Controllers'
  ,'eshop.Directives'
  ,'eshop.Factories'
  ,'eshop.Controllers'
]);

eshopApp.config(function($interpolateProvider){
  $interpolateProvider.startSymbol('{[').endSymbol(']}');
});

// Needed for xeditable
eshopApp.run(function(editableOptions) {
  editableOptions.theme = 'bs3'; // bootstrap3 theme. Can be also 'bs2', 'default'
});


// configure our routes
//eshopApp.config(function($routeProvider) {
//  $routeProvider
//    // route for the home page
//    .when('/', {
//      template : " ",
//      controller  : 'ControllerLanding',
//      animation : 'slide'
//    })
//});


// configure our routes
eshopApp.config(function($stateProvider,$urlRouterProvider) {
  $urlRouterProvider.otherwise('/home/shop');

  $stateProvider
  
  .state('home', {
    url : '/home',
    controller : 'ControllerLanding',   
    templateUrl: function ($stateParams){
      console.log('home activated: ',$stateParams);
      return '/app/templates/home.tpl';
    }
  })


   .state('shop' : {  controller : 'ControllerShop',
	      templateUrl: function ($stateParams) {
	        console.log('shop activated: ',$stateParams);
	        return '/app/templates/shopView.tpl';
	      }
           }



  .state('admin', {
    url : 'admin',
    controller : 'ControllerAdmin',
    templateUrl: function ($stateParams){
      console.log('admin activated: ',$stateParams.filterBy);
      return '/app/templates/admin.tpl';
    }
  })

  .state('start', {
    url : '/start',
    templateUrl: function ($stateParams){
      console.log('admin.start activated: ',$stateParams.filterBy);
      return '/app/templates/adminStart.tpl';
    }
  })
 
});

eshopApp.run(

function($rootScope) {
$rootScope.$on('$stateChangeStart',function(event, toState, toParams, fromState, fromParams){
  console.log('$stateChangeStart to '+toState.to+'- fired when the transition begins. toState,toParams : \n',toState, toParams);
});
$rootScope.$on('$stateChangeError',function(event, toState, toParams, fromState, fromParams, error){
  console.log('$stateChangeError - fired when an error occurs during transition.');
  console.log('from',fromState);
  console.log('to',toState);
  console.log('error',error);
});
$rootScope.$on('$stateChangeSuccess',function(event, toState, toParams, fromState, fromParams){
  console.log('$stateChangeSuccess to '+toState.name+'- fired once the state transition is complete.');
});

$rootScope.$on('$viewContentLoading',function(event, viewConfig){
   // runs on individual scopes, so putting it in "run" doesn't work.
  console.log('$viewContentLoading - view begins loading - dom not rendered',viewConfig);
});
$rootScope.$on('$viewContentLoaded',function(event){
  console.log('$viewContentLoaded - fired after dom rendered',event);
  });
$rootScope.$on('$stateNotFound',function(event, unfoundState, fromState, fromParams){
  console.log('$stateNotFound '+unfoundState.to+'  - fired when a state cannot be found by its name.');
     console.log(unfoundState, fromState, fromParams);
 });
}

);
