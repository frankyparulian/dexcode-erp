window.Dispatcher = Flux.Dispatcher;
window.React = require('react');
window.ReactDOM = require('react-dom');
window._ = require('lodash');
window.classNames = require('classnames')
// _.assign(window, require('material-ui'));
window.DatePicker = require('react-datepicker');
window.Formsy = require('formsy-react');

var injectTapEventPlugin = require('react-tap-event-plugin');
injectTapEventPlugin();

window.dispatcher = new Dispatcher();
