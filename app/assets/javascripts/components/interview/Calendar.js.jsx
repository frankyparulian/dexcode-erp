
var HiddenInput = React.createClass({
  mixins: [Formsy.Mixin],
  componentWillUpdate: function (nextProps, nextState) {
    if (nextProps.schedule !== this.props.schedule) {
      this.setValue(moment(nextProps.schedule).format());
    }
  },
  handleChange: function(event) {
    this.setValue(event.target.value);
  },
  render: function(){
    return (
      <input type="text" className="hidden" onChange={this.handleChange} value={moment(this.props.schedule).format()}/>
    );
  }
});

var Time = React.createClass({
  handleClick: function () {
    this.props.selectTime(this.props.hour,this.props.status);
  },
  render: function () {
    var schedule= this.props.schedule;
    var hour = this.props.hour;
    var status = this.props.status;
    var timeClasses = classNames(
      'time-box',
      { 'time-selected': (schedule && schedule.format('H') == hour) && (status!==true) }, {'time-booked': status == true }
    );

    return (
      <li className={timeClasses}
           onClick={this.handleClick} >

           <div className="time">
           {this.props.hour}.00 {moment().hour(this.props.hour).format('a')}
           </div>

             <div className="book" >
             {this.props.status==true ? "booked" : ""} </div>

      </li>
    );
  },
});

var TimeList = React.createClass({
  componentWillUpdate: function(nextProps, nextState) {
    if (nextProps.selected !== this.props.selected) {
      // request booked
      // on success request dispatch
      var payload = {
        interview:{
          schedule: nextProps.selected.format('YYYY-MM-DD')
        }
      }

      $.ajax({
        method  : 'POST',
        url     : 'interviews/interviewee',
        dataType: 'json',
        data    : JSON.stringify(payload),
        contentType: 'application/json',
        success: function(response){
            var interviews = response.interviews;
          _.each(interviews, function(interview, i) {
            interview.schedule = moment(interview.schedule)
          });
          dispatcher.dispatch({
            actionType: 'calendar-booked-add',
            booked: interviews
          })
        }

      });

    }
  },

  renderTime: function () {
    var times = [];
    var bookLength = this.props.booked.length;
    for (var i = 9; i <= 18; i++) {
      var statusbook = false;
      // console.log('this.props.booked', this.props.booked)
      for (var j = 0; j < bookLength; j++){
       if (moment(this.props.booked[j].schedule).utc().format('H') == i){
         statusbook = true;

         break;
       }
      }
      // console.log("statusbook",moment(this.props.booked.schedule).format('H'));
      // console.log("name",this.props.booked.schedule);
      times.push(<Time key={i}
                       schedule={this.props.schedule}
                       selectTime={this.props.selectTime}
                       hour={i}
                       booked={this.props.booked}
                       status={statusbook}/>);
    }

    return times;
  },

  render: function () {
    return (
      <div className="time-container text-left">
        {this.renderTime()}
      </div>
    );
  },
});

var Day = React.createClass({
  getDay: function (dayOfWeek) {
    return moment(this.props.current).day(dayOfWeek);
  },

  handleClick: function () {
    this.props.handleClick(this.getDay(this.props.dayOfWeek));
  },

  render: function () {
    var current = this.props.current;
    var dateClasses = classNames(
      'day',
      { 'selected': this.props.selected.format('YYYY-MM-DD') === moment(current).day(this.props.dayOfWeek).format('YYYY-MM-DD') }
    );

    function getDay(dayOfWeek) {
      return moment(current).day(dayOfWeek);
    }

    return (
      <div className="day-container">
        <div className="weekday">{getDay(this.props.dayOfWeek).format('ddd')}</div>
        <div className={dateClasses}
             onClick={this.handleClick}><b>{getDay(this.props.dayOfWeek).format('DD')}</b></div>
      </div>
    );
  },
});

var DayName = React.createClass({
  renderDays: function () {
    var days = [];
    for (var i = 0; i < 7; i++) {
      days.push(<Day key={i} selected={this.props.selected} current={this.props.current} dayOfWeek={i} handleClick={this.props.onSelect} />);
    }

    return days;
  },

  render: function () {
    var current = this.props.current;

    function getDay(dayOfWeek) {
      return moment(current).day(dayOfWeek).format('DD');
    }

    function dateSelect(dayOfWeek) {
      return current.format('DD') == moment(current).day(dayOfWeek).format('DD') ? "day selected" : "day";
    }

    return (
      <div className="row">
      <div onClick={this.props.prevWeek} className="arrow fa fa-chevron-left"></div>
        {this.renderDays()}

        <div onClick={this.props.nextWeek} className="arrow fa fa-chevron-right"></div>
      </div>
    );
  },
});

var HeaderMonth = React.createClass({
  render: function () {
    return (
      <div className="headermonth">
        <strong>{this.props.current.format('MMMM, YYYY')}</strong>
      </div>
    );

  },

});

var Calendar = React.createClass({
  getInitialState: function () {
    return CalendarStore.get();
  },

  setBook: function(){
    var that = this;

    var selected = this.state.selected.format('YYYY-MM-DD');

    CalendarWebUtil.fetchBooked(selected).success(function(response){
      var interviews = response.interviews;
      _.each(interviews, function (interview, i){
        interviews.schedule = moment(interview.schedule)
      });
    });
  },

  componentDidMount: function () {
    this.setBook();
    CalendarStore.addChangeListener(this.onChange);
  },

  componentWillUnmount: function () {
    CalendarStore.removeChangeListener();
  },

  onChange: function () {
    this.setState(CalendarStore.get());
    var newState = CalendarStore.get();
    console.log('newState.selected',newState.selected && newState.selected.format())
    console.log('newState.schedule',newState.schedule && newState.schedule.format())
  },

  selectTime: function (hour, bookstatus){
    if(bookstatus !== true){
      var schedule = moment(this.state.selected).hour(hour).minute(0).second(0);
      dispatcher.dispatch({
        actionType: 'calendar-update',
        calendar: {
          schedule: schedule
        }
      });
    }
  },

  prevWeek: function () {
    dispatcher.dispatch({
      actionType: 'calendar-update',
      calendar: {
        current: this.state.current.day(-7)
      }
    });
  },
  nextWeek: function () {
    dispatcher.dispatch({
      actionType: 'calendar-update',
      calendar: {
        current: this.state.current.day(7)
      }
    });
  },

  handleSelect: function (selected) {
    dispatcher.dispatch({
      actionType: 'calendar-update',
      calendar: {
        selected: selected,
        schedule: this.state.schedule &&  moment(selected).hour(this.state.schedule.hour()).minute(this.state.schedule.minute())
      }
    });

  },

  render: function () {
    return (
      <div className="calendar">
      <HeaderMonth current={this.state.current}/>
          <DayName current={this.state.current}
                   selected={this.state.selected}
                   onSelect={this.handleSelect}
                   prevWeek={this.prevWeek}
                   nextWeek={this.nextWeek}
                   />
                 <TimeList Time={this.state.schedule}
                           selectTime={this.selectTime}
                           schedule={this.state.schedule}
                           booked={this.state.booked}
                           selected={this.state.selected}/>
        <HiddenInput name="schedule" schedule={this.state.schedule} required/>
      </div>
    );
  }
});
