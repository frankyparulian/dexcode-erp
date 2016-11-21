app = angular.module('dexcode');

app.controller('CreateScheduleInterviewController', ['$scope', '$http',
  function($scope, $http) {
    $scope.interview = {};


    $scope.submit = function ($event) {
      $event.preventDefault();

      // Post FormData
      $http.post('/interviews.json', $scope.interview )
        .success(function (result) {
          console.log(result+"success");
          window.location = '/interviews';
        })
        .error(function (result) {
          console.log(result+"failed");
          window.location = '/interviews';
        })
    };
  }
]);
