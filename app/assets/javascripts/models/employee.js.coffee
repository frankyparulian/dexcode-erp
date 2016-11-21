app = angular.module('dexcode')

app.factory('Employee', ['railsResourceFactory',
  (railsResourceFactory) ->
    return railsResourceFactory({
      url: '/employees',
      name: 'employee'
    })
])
