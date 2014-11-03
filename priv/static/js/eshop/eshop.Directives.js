'use strict';

var eshopDirectives = angular.module('eshop.Directives',[]);

// --------------- Sign Up ------------------

eshopDirectives.directive('DirectiveShowErrors', function($timeout) {
  return {
    restrict: 'A',
    require: 'ngModel',
    link: function (scope, element, atts, controller) {
      controller.$focused = false;
      element
	.bind('focus', function(e) {
	  scope.$apply(function() { controller.$focused = true; } );
        })
        .bind('blur', function(e) {
            scope.$apply(function() { controller.$focused = false; } );
	    scope.$apply(atts.showErrors);
        });
    }
  }
});

eshopDirectives.directive('DirectivePasswordVerify', function($timeout) {
  return {
    restrict: 'A',
    require: 'ngModel',
    scope: {
      passwordVerify: '='
    },
    link: function (scope, element, atts, controller) {
      element
        .bind('blur', function(e) {
          scope.$apply(function() {
	    if (scope.passwordVerify !== controller.$viewValue) {
	      controller.$setValidity('passwordVerify', false);
	    } else {
	      controller.$setValidity('passwordVerify', true);
	    };
	  });
        });    
    }
  }
});


