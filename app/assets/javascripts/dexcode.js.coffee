# Initialize module
app = angular.module('dexcode', [
  'angularFileUpload', 'ui.bootstrap', 'rails'
])

# Configure datepicker
app.config(['datepickerConfig',
  (datepickerConfig) ->
    datepickerConfig.showWeeks = false  # Disable weeks number
    datepickerConfig.startingDay = 1    # Monday
])
