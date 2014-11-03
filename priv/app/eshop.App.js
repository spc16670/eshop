
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
  ,'servicePartials'
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
  
  .state('admin', {
    url : '/admin',
    views : { 
      "main" : {

//        template : "<h1>hello</h1>"
//    controller : 'ControllerLanding',  
    templateProvider: function (ServicePartials,$timeout,$stateParams) {
        console.log('admin activated: ',$stateParams.id);
        ServicePartials.fetch('homeTemplate');
        var promise = ServicePartials.promise;
        return promise.then(function(response) {
          console.log("template resp ",response.data.partial);
          return response.data.partial;
        });
       
    }
//

      }
    }
  })

  .state('start', {
    url : '/start',
    templateUrl: function (){
      console.log('admin.start activated ');
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