app = angular.module('dexcode')

app.controller 'InvoiceController', [
  '$scope'
  ($scope) ->
    $scope.taxPercent = 0

    newId = ->
      new Date().getTime()

    $scope.invoiceItems = [{ id: newId(), description: '', hours: '', rate: '' }]

    $scope.init = (taxPercent) ->
      $scope.taxPercent = taxPercent

    $scope.addItem = ->
      $scope.invoiceItems.push({ id: newId(), description: '', hours: '', rate: '' })

    $scope.removeItem = (item) ->
      $scope.invoiceItems.splice($scope.invoiceItems.indexOf(item), 1)
      $scope.addItem() if $scope.invoiceItems.length == 0

    $scope.subtotal = ->
      total = 0.00
      for item in $scope.invoiceItems
        total += item.hours * item.rate
      total

    $scope.tax = ->
      $scope.taxPercent * $scope.subtotal() / 100

    $scope.grand_total = ->
      $scope.tax() + $scope.subtotal()
]
