app = angular.module('dexcode');

app.controller('DatePickerController', ['$scope', '$http', function($scope,$http) {
  $scope.formData = {};
  $scope.interviewee = {};
  $scope.interviews = [];
  $scope.dt = new Date();
  $scope.minDate = null ;
  $scope.viewLoading = false;
  $scope.stateOptions = [
    {value: 'scheduled', label: 'Scheduled'},
    {value: 'noshow', label: 'No Show'},
    {value: 'hired', label: 'Hired'},
    {value: 'rejected', label: 'Rejected'}
  ];

  //disable weekend selection
  $scope.disabled = function(date, mode) {
    return (mode == 'day' && (date.getDay() === 0 || date.getDay() === 6 ));
  };



  $scope.open = function($event) {
    $event.preventDefault();
    $event.stopPropagation();

    $scope.opened  = true;
  };

  $scope.loadInterviews = function() {
    $scope.viewLoading = true;
    $scope.formData.schedule = moment($scope.dt).format('YYYY-MM-DD');
    console.log(($scope.formData));

    $http({
      method  : 'POST',
      url     : 'interviews/interviewee',
      dataType: "json",
      data    : {interview: $scope.formData },
      headers : {'Content-Type': 'application/json; charset=utf-8'}
    }).success(function(result) {
      $scope.viewLoading = false;
      $scope.interviews = result;
      angular.forEach($scope.interviews, function(time,i) {
        $scope.interviews[i].time = moment(time.schedule).zone('+0000').format('hh:mm a');
      });
      console.log($scope.interviews);
    }).error(function(result) {
      $scope.viewLoading = false;
      console.log("gagal");
    });
  };

  $scope.submit = function($event) {
    $scope.loadInterviews();
  };

  $scope.loadState  = function(interview) {
    $scope.viewLoading = true;
    $http({
      method    : 'PUT',
      url       : 'interviews/state',
      dataType  : 'json',
      data      : { interview: interview },
      headers   : {'Content-Type': 'application/json; charset=utf-8'}
    }).success(function(result) {
      $scope.viewLoading = false;
      $scope.loadInterviews();
      console.log($scope.interviews);
    }).error(function(result) {
      $scope.viewLoading = false;
      console.log($scope.interviewee);
      console.log("gagal");
    });
  };
  $scope.updateState = function($event,interview) {
    $scope.loadState(interview);
  };

  $scope.dateOptions = {
    formatYear: 'yy',
    startingDay: 0
  };

  $scope.formats = ['yyyy-MM-dd', 'dd-MMMM-yyyy', 'dd.MM.yyyy', 'shortDate'];
  $scope.format = $scope.formats[0];

  $scope.loadInterviews();

}]);
