//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require twitter/bootstrap
//
//  Vendor Plugins
//  -------------------------------------------------------------------------
//= require datepicker/picker
//
//= require angular-file-upload-shim
//= require angular
//= require angular-file-upload
//= require angular-ui-bootstrap-tpls
//= require angularjs/rails/resource
//= require jquery.datetimepicker
//= require moment
//= require daterangepicker
//= require spin.min
//= require uri.min
//= require datepicker
//= require select2
//= require jquery.raty.min
//= require highchart.min
//= require highchart_table
//= require icheck
//
//= require_tree ./initializers
//
//= require dexcode
//= require_tree ./models
//= require_tree ./directives
//= require_tree ./controllers
//
//= require flux
//= require fbemitter
//= require components
//= require react_ujs
//= require_tree ./stores
//= require components/utils/calendarWebUtil
//= require components/utils/interviewWebUtil
//= require components/interview/Calendar
//= require components/interview/InterviewApp
//
//= require time_entry
//= require feedback


$(document).ready(function() {
  // Used in interview page
  jQuery('#dateTimePicker').datetimepicker({
    defaultDate: '2014-11-11',
    defaultTime: '00:00',
    format: 'Y-m-d H:i',
    minDate: '0',
    inline: true,
    lang: 'en'
  });

  $(".jquery-datepicker").datepicker({ dateFormat: 'yy-mm-dd' });
  $('#reportrange span').html(moment().subtract(29, 'days').format('MMMM D, YYYY') + ' - ' + moment().format('MMMM D, YYYY'));
  $(".first-date").val(moment().subtract(29, 'days').format('YYYY/MM/DD'));
  $(".end-date").val(moment().format('YYYY/MM/DD'));
  $('#reportrange').daterangepicker({
         format: 'MM/DD/YYYY',
        startDate: moment().subtract(29, 'days'),
        endDate: moment(),
        // minDate: '01/01/2012',
        // maxDate: '12/31/2015',
        // dateLimit: { days: 60 },
        showDropdowns: true,
        showWeekNumbers: true,
        timePicker: false,
        timePickerIncrement: 1,
        timePicker12Hour: true,
        ranges: {
           'Today': [moment(), moment()],
           'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
           'Last 7 Days': [moment().subtract(6, 'days'), moment()],
           'Last 30 Days': [moment().subtract(29, 'days'), moment()],
           'This Month': [moment().startOf('month'), moment().endOf('month')],
           'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
        },
        opens: 'left',
        drops: 'down',
        buttonClasses: ['btn', 'btn-sm'],
        applyClass: 'btn-primary',
        cancelClass: 'btn-default',
        separator: ' to ',
        locale: {
            applyLabel: 'Submit',
            cancelLabel: 'Cancel',
            fromLabel: 'From',
            toLabel: 'To',
            customRangeLabel: 'Custom',
            daysOfWeek: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr','Sa'],
            monthNames: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
            firstDay: 1
        }
  });
  $('#reportrange').on('apply.daterangepicker', function(ev, picker) {
    $('#reportrange span').html(picker.startDate.format('MMMM D, YYYY') + ' - ' + picker.endDate.format('MMMM D, YYYY'));
    $(".first-date").val(picker.startDate.format('YYYY/MM/DD'));
    $(".end-date").val(picker.endDate.format('YYYY/MM/DD'));
    $(this).parents(".form-se").submit();
  });

  $(".m-select").select2();

  $("#notice").fadeTo(2000, 500).fadeOut(500, function() {
    $("#notice").alert('close');
  });

  $("#alert").fadeTo(2000, 500).fadeOut(500, function() {
    $("#alert").alert('close');
  });
});
