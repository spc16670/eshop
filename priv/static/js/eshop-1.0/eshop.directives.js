'use strict';

var eshopDirectives = angular.module('eshopDirectives',[]);

// --------------- Sign Up ------------------

eshopDirectives.directive('showErrors', function($timeout) {
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

eshopDirectives.directive('passwordVerify', function($timeout) {
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


// --------------- Categories ------------------

eshopDirectives.directive('eshopCategories', function() {
  var template = '<form name="formHandleCategory-{[ category.data.id ]}" ' + 
                 'class="form-group" role="form" novalidate><div class="row"> ' +
                 '<div class="col-sm-3">'  +
                    '<a href="#" editable-form="category.data.name">{[ category.data.name ]}</a>' +
                  '</div>' +
                  '<div class="col-sm-6">' +
                    '<h5>{[ category.data.description ]}</h5>' +
                  '</div>' +
                  '<div class="col-sm-3">' +
                   ' <div>' +
                    '  <button type="button" class="btn btn-warning" ng-click="handleCategory({ obj : category})">Modify</button>' +
                    '  <button type="button" class="btn btn-danger" ng-click="handleCategory({ obj : category})">Remove</button>' +
                    '</div>' +
                  '</div>' +
                '</div>' +
                '</form>';
  return {
    restrict: "A",
    replace: true,
    scope: true,
    template: template,
    link: function (scope, element, atts, controller) {
      scope.$watch('categories', function(newValue, oldValue) {
        console.log('newValue ',newValue);
      });
    }
  }
});


