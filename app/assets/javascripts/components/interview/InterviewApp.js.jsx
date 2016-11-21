
var InputName = React.createClass({
  mixins: [Formsy.Mixin],
  componentWillUpdate: function (nextProps, nextState){
    if(this.props.intervieweeName !== nextProps.intervieweeName){
      this.setValue(nextProps.intervieweeName)
    }
  },

  changeValue: function(event){
    this.setValue(event.currentTarget.value);
    this.props.handleNameChange(event.currentTarget.value);
  },
  render: function (){
    var className = this.showRequired() ? 'required' : this.showError() ? 'error' : null;
    var errorMessage = this.getErrorMessage();
    return(
      <div className="form-group text-left">
      <label>Interviewee Name</label>
      <input name="name" className="form-control long" type="text" onChange={this.changeValue} value={this.props.intervieweeName}/>
        <span>{errorMessage}</span>
      </div>
    );
  }
});

var InputEmail = React.createClass({
  mixins: [Formsy.Mixin],
  componentWillUpdate: function (nextProps, nextState){
    if(this.props.intervieweeEmail !== nextProps.intervieweeEmail){
      this.setValue(nextProps.intervieweeEmail)
    }
  },

  changeValue: function(event){
    this.setValue(event.currentTarget.value);
    this.props.handleEmailChange(event.currentTarget.value);
  },
  render: function(){
    var className = this.showRequired() ? 'required' : this.showError() ? 'error' : null;
    var errorMessage = this.getErrorMessage();
    return(
      <div className="form-group text-left">
      <label>Intervieweee Email</label>
      <input className="form-control long" type="email" onChange={this.changeValue} value={this.getValue()}/>
        <span>{errorMessage}</span>
      </div>
    );
  }
});

var FormNewSchedule = React.createClass({
  getInitialState: function() {
    return {
      canSubmit: false
    }
  },
  enableButton: function() {
    this.setState({
      canSubmit: true
    });
  },
  disableButton: function() {
    this.setState({
      canSubmit: false
    });
  },
  submit: function(model) {
    // someDep.saveEmail(model.email);
    this.props.addSchedule();
    console.log("asem",this.props.addSchedule);
  },
  render: function(){
    return (
      <Formsy.Form onValidSubmit={this.submit} onValid={this.enableButton} onInvalid={this.disableButton}>
        <InputName  name="name" required
        handleNameChange={this.props.handleNameChange} intervieweeName={this.props.intervieweeName}/>

        <InputEmail className="form-control long" name="email" validations="isEmail" validationError="this is not a valid email" required
        intervieweeEmail={this.props.intervieweeEmail}
        handleEmailChange={this.props.handleEmailChange} />

        <Calendar />


        <button type="submit" disabled={!this.state.canSubmit} className="btn btn-m- btn-primary long submit" >Add Schedule</button>

      </Formsy.Form>

    );
  }
});


var OptionsState = React.createClass({
  handleChange: function(event) {
    this.props.updateInterviewee(this.props.interviewee, event.target.value);
  },
  render: function(){
    var liststate = ["schedule","noshow","hired","rejected"];
    var interviewee = this.props.interviewee;
    // console.log('this.props', this.props)
    return (
      <select onChange={this.handleChange} className="form-control">
      {liststate.map(function(state){
        return (
          <option selected={state === interviewee.state} value={state}>{state}</option>
        );
      })}
      </select>
    );
  }
});

var Loader = React.createClass({

  render: function(){

    var loaderClass = classNames(
      "loader text-center"
    )

    return (
      <div className={loaderClass} >
        <img src={DexcodeERP.img_loader_url} />
      </div>
    );
  }
});

var InterviewDataBody = React.createClass({
  render: function(){
    var i = 1;
    console.log(this.props  )
    var hidableClassName = this.props.toggleNew ? 'hidden' : '';
    var that = this;
    return(
      <tbody>
      {this.props.dataInterviewee.map(function(interviewee, index) {
        return (
          <tr key={interviewee.id}>
            <td>{index + 1}</td>
            <td>{interviewee.name}</td>
            <td className={hidableClassName}>{interviewee.email}</td>
            <td className={hidableClassName}>{interviewee.time}</td>
            <td className={hidableClassName}><a className="btn btn-md btn-danger" onClick={that.props.destroyInterview.bind(this, interviewee)}>Delete</a></td>
            <td className={hidableClassName}>
            <OptionsState interviewee={interviewee} updateInterviewee={that.props.updateInterviewee}/>
            </td>
          </tr>
        );
      })}
      </tbody>
    );
  }
});

var InterviewIndex = React.createClass({
  render: function(){
    var hidableClassName = this.props.toggleNew ? 'hidden' : '';

    return(
      <div className="table table-responsive">
        <table className="table table-striped">
          <thead>
            <tr>
              <th>No</th>
              <th>Name</th>
              <th className={hidableClassName}>Email</th>
              <th className={hidableClassName}>Time</th>
              <th className={hidableClassName}>Action</th>
              <th className={hidableClassName}>State</th>
            </tr>
          </thead>
          <InterviewDataBody dataInterviewee={this.props.dataInterviewee}
                             updateInterviewee={this.props.updateInterviewee}
                             destroyInterview={this.props.destroyInterview}
                             toggleNew={this.props.toggleNew} />
        </table>
      </div>
    );
  }
});

var FilterDate = React.createClass({
  handleChange: function(date){
    this.props.onDateChange(date);
    console.log('FilterDate handleChange')
  },
  render: function(){
    return(
      <DatePicker className="long"
      selected={this.props.date}
      onChange={this.handleChange}
       />
    );
  }
});

var ButtonNewSchedule = React.createClass({
  render: function(){
    return(
      <button className="btn btn-lg btn-info" onClick={this.props.toggleNewSchedule}>New Schedule</button>
    );
  }
});

var InterviewApp = React.createClass({
  getInitialState: function () {

    return {
      filterDate: moment(),
      interviewees: [],
      toggleNew: false,
      intervieweeName: "",
      intervieweeEmail: ""
    };
  },

  handleNameChange: function (name) {
    this.setState({ intervieweeName: name })
  },

  handleEmailChange: function (email) {
    this.setState({ intervieweeEmail: email })
  },

  addSchedule: function(){
    var calendar = CalendarStore.get();

      var that = this;
      console.log("calendarku",calendar.schedule.format());

      var intervieweeName = this.state.intervieweeName;
      var intervieweeEmail = this.state.intervieweeEmail;
      var schedule = calendar.schedule.format('YYYY-MM-DD HH:mm:ss');

      InterviewWebUtil.fetchAddSchedule(intervieweeName,intervieweeEmail,schedule).success(function(response) {
        that.setState({
          intervieweeName: "",
          intervieweeEmail: ""
        });
        dispatcher.dispatch({
          actionType: 'calendar-update',
          calendar: {
            schedule: null,
            selected: moment()
          }
      });

        that.toggleNewSchedule();
        that.loadInterviewee(that.state.filterDate);
      })
      .error(function(response) {
        console.log('error', response)
      })

  },

  toggleNewSchedule: function(){
    this.setState({toggleNew: !this.state.toggleNew})
  },

  updateIntervieweeState: function(interviewee, state){
    // console.log(interviewee);
    var payload = {
      interview: {
        id: interviewee.id , state: state
      }
    }

  InterviewWebUtil.fetchUpdateState(interviewee.id,state)

  },

  loadInterviewee: function(filterDate) {

    var payload = {
      interview: {
        schedule: filterDate.format('YYYY-MM-DD')
      }
    };

    var that = this;

    InterviewWebUtil.fetchLoadInterviewees(filterDate)
    .success(function(result){
      if (result.interviews) {
          var interviews = result.interviews;
          console.log('sukses', interviews);
          _.each(interviews, function(interview, i) {
            interview.time = moment(interview.schedule).utcOffset('+0000').format('hh:mm a');
          });
          that.setState({interviewees: interviews})
          dispatcher.dispatch({
            actionType: 'interview-set',
            interviews: interviews
          })
        }
    });

  },

  handleDestroyInterview: function(interviewee, e){
    var that = this;
    InterviewWebUtil.deleteSchedule(interviewee.id).success(function(){
      that.setState({
        interviewees: that.state.interviewees.filter(function(inter){
          return inter.id !== interviewee.id;
        })
      })
    });
  },

  componentDidMount: function() {
    this.loadInterviewee(this.state.filterDate)
    InterviewStore.addChangeListener(this.onChange)

  },
  componentWillUnmount: function() {
    console.log("remove listener")
    InterviewStore.removeChangeListener(this.onChange)
  },
  handleDateChange: function(date){
    this.loadInterviewee(date)
    this.setState({
      filterDate: date
    });
  },

  onChange: function() {
    this.setState(InterviewStore.getAll());
  },
  render: function(){
    var leftColClassName = this.state.toggleNew ? 'col-md-6' : 'col-md-12';
    var colRight = this.state.toggleNew ? false : true;

    return (
      <div className="container interview">

        <div className={leftColClassName}>

          <div className="row date_picker">

            <div className="col-md-3">
              <FilterDate onDateChange={this.handleDateChange} date={this.state.filterDate}/>
            </div>

            <div className="col-md-9 text-right ">
              <ButtonNewSchedule toggleNewSchedule={this.toggleNewSchedule}/>
            </div>

          </div>

          <div className="row">
            <Loader/>
            <InterviewIndex dataInterviewee={this.state.interviewees}
                            updateInterviewee={this.updateIntervieweeState}
                            destroyInterview={this.handleDestroyInterview}
                            toggleNew={this.state.toggleNew} />


          </div>
        </div>

        <div className="col-md-6 text-center" hidden={colRight} >
          <FormNewSchedule addSchedule={this.addSchedule}
                           handleNameChange={this.handleNameChange}
                           handleEmailChange={this.handleEmailChange}
                           intervieweeName={this.state.intervieweeName}
                           intervieweeEmail={this.state.intervieweeEmail}/>
        </div>


      </div>
    );
  }
});


window.InterviewApp = InterviewApp;
