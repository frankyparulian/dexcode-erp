app = angular.module("dexcode");

app.directive('loadingSpinner', function() {
  return {
    restrict  : 'A',
    replace   : true,
    transclude: true,
    scope     : {
      loading: '=loadingSpinner'
    },
    templateUrl: "/templates/shared/loading.html",
    link       : function(scope, element, attrs) {
      var spinner = new Spinner().spin();
      var loadingContainer = element.find('.loading-spinner-container')[0];
      loadingContainer.appendChild(spinner.el);
    }
  };
});
