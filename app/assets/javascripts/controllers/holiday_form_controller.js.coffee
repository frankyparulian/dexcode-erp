app = angular.module('dexcode')

app.controller('HolidayFormController', ['$scope',
  ($scope) ->
    console.log('Test')
    $scope.holiday = {}

    $scope.startDatePopupOpened = false
    $scope.endDatePopupOpened = false

    $scope.openStartDatePopup = ->
      $scope.startDatePopupOpened = true

    $scope.openEndDatePopup = ->
      $scope.endDatePopupOpened = true
])
