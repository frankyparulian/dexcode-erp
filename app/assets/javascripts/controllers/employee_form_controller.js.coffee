app = angular.module('dexcode')

app.controller('EmployeeFormController', ['$scope', 'Employee',
  ($scope, Employee) ->
    $scope.employee = {}

    $scope.startDatePopupOpened = false
    $scope.endDatePopupOpened = false

    $scope.init = (employeeId) ->
      if employeeId
        Employee.get(employeeId).then (employee) ->
          $scope.employee = employee

    $scope.openStartDatePopup = ->
      $scope.startDatePopupOpened = true

    $scope.openEndDatePopup = ->
      $scope.endDatePopupOpened = true
])
