$(document).ready(function() {
  $('#project_id').change(function() {
    var projectId = $(this).val();
    var employeeId = $('#employee').val();

    $.ajax({
      type: 'GET',
      url: 'time_entries.json',
      data: { time_entry: { employee_id: employeeId ,project_id: projectId } },
      beforeSend: function() {
        $('.loader').show();
      }
    }).done(function(response) {
      for( var i = 0; i < 7; i++) {
        $('#date-' + i).val(response[i]);
      }
    }).complete(function() {
      $('.loader').hide();
    });
  });

  $('#employee').change(function() {
    var projectId = $('#project_id').val();
    var employeeId = $(this).val();

    $.ajax({
      type: 'GET',
      url: 'time_entries.json',
      data: { time_entry: { employee_id: employeeId ,project_id: projectId } },
      beforeSend: function() {
        $('.loader').show();
      }
    }).done(function(response) {
      for( var i = 0; i < 7; i++) {
        $('#date-' + i).val(response[i]);
      }
    }).complete(function() {
      $('.loader').hide();
    });
  });

  $('#prev-week-navigation').click(function() {
    var projectId = $('#project_id').val();
    var employeeId = $('#employee').val();
    var currentYear = $('#time_entry_current_year').val();
    var currentWeek = $('#time_entry_current_week_of_year').val();
    var previousWeek = parseInt(currentWeek) - 1;
    console.log(employeeId);
    $.ajax({
      type: 'GET',
      url: '/time_entries.json',
      data: { time_entry:
        { employee_id: employeeId ,project_id: projectId,
          display_current_year: currentYear,
          display_current_week: currentWeek, previous: true }
      },
      beforeSend: function() {
        $('.loader').show();
      }
    }).done(function(response) {
      var week_dates = response[7]['week_dates'];
      for( var i = 0; i < 7; i++) {
        $('#date-' + i).val(response[i]);
        $('#dates-' + i).val(week_dates[i]);
        if(week_dates[i] > response[7]['current_date']) {
          $('#date-' + i).attr('readonly', 'readonly');
        } else {
          $('#date-' + i).removeAttr('readonly', 'readonly');
        }
      }
      $('.begin-week').text(response[7]['begin_date']);
      $('.end-week').text(response[7]['end_date']);
      $('#time_entry_current_week_of_year').val(previousWeek);
    }).complete(function() {
      $('.loader').hide();
    });
  });

  $('#next-week-navigation').click(function() {
    var projectId = $('#project_id').val();
    var employeeId = $('#employee').val();
    var currentYear = $('#time_entry_current_year').val();
    var currentWeek = $('#time_entry_current_week_of_year').val();
    var nextWeek = parseInt(currentWeek) + 1;

    $.ajax({
      type: 'GET',
      url: 'time_entries.json',
      data: { time_entry:
        { employee_id: employeeId ,project_id: projectId,
          display_current_year: currentYear,
          display_current_week: currentWeek, previous: false }
      },
      beforeSend: function() {
        $('.loader').show();
      }
    }).done(function(response) {
      var week_dates = response[7]['week_dates'];
      for( var i = 0; i < 7; i++) {
        $('#date-' + i).val(response[i]);
        $('#dates-' + i).val(week_dates[i]);
        if(week_dates[i] > response[7]['current_date']) {
          $('#date-' + i).attr('readonly', 'readonly');
        } else {
          $('#date-' + i).removeAttr('readonly', 'readonly');
        }
      }
      $('.begin-week').text(response[7]['begin_date']);
      $('.end-week').text(response[7]['end_date']);
      $('#time_entry_current_week_of_year').val(nextWeek);
    }).complete(function() {
      $('.loader').hide();
    });
  });

});
