/*****************************************************************************/
/* Copyright (c) Clockstar s.r.o. All rights reserved.                       */
/*****************************************************************************/
/*                                                                           */
/* RIC Calendar                                                              */
/*                                                                           */
/* Author: Matěj Outlý                                                       */
/* Date  : 9. 3. 2017                                                        */
/*                                                                           */
/*****************************************************************************/

/**
 * Ric Calendar builder class
 *
 * Initializes fullcalendar.io and extends its functionality. Provides connection
 * between javascript fullcalendar library and Rails application. Adds ability to
 * persistently save calendar view state for better user experience.
 *
 * Options:
 * - url ... (string) Rails path to event source (usually `events_calendars_path`)
 * - newUrl .... (string) Rails path to new event action. Adds `date` as get param to path.
 * - allowedCallendars ... (function) Function which ...
 */

function RicCalendar(hash, options)
{
	this.hash = hash;
	this.calendar = null;
	this.options = (typeof options !== 'undefined' ? options : {});

	// Local storage key
	this._localStorageKey = 'ric_calendar_' + hash;

	// Ignore view render callback during fullcalendar load
	this._ignoreViewRenderCallback = true;
}
RicCalendar.prototype = {
	constructor: RicCalendar,

	//
	// Drag&drop events editation
	//
	moveEvent: function(event, delta, revertFunc)
	{
		var self = this;

		var datetimeFrom = event.start;
		var datetimeTo = event.end;
		var oldDatetimeFrom = event.oldStart;
		var oldDatetimeTo = event.oldEnd;
		var editUrl = event.editUrl;

		var dateFrom = (datetimeFrom ? datetimeFrom.format("YYYY-MM-DD") : null);
		var timeFrom = (datetimeFrom && datetimeFrom.hasTime() ? datetimeFrom.format("HH:mm:ss") : null);
		var dateTo = (datetimeTo ? datetimeTo.format("YYYY-MM-DD") : dateFrom);
		var timeTo = (datetimeTo && datetimeTo.hasTime() ? datetimeTo.format("HH:mm:ss") : timeFrom);
		var allDay = !datetimeFrom.hasTime();

		var scheduledDateFrom = (oldDatetimeFrom ? oldDatetimeFrom.format("YYYY-MM-DD") : null);

		// Move to another time
		var ajax_data = {
			all_day: allDay,
			date_from: dateFrom,
			time_from: timeFrom,
			date_to: dateTo,
			time_to: timeTo,
			scheduled_date_from: scheduledDateFrom,
			update_action: "only_this",
		};

		$.post({
			url: editUrl,
			data: {
				event: ajax_data,
				_method: "PATCH",
			},
			dataType: 'json',
			success: function(result) {
				if (result === true) {
					// Refetch all events (TODO: should be improved in the future...)
					self.calendar.fullCalendar('refetchEvents')
				}
				else {
					revertFunc();
				}
			},
			error: function() {
				revertFunc();
			},
		});
	},

	//
	// Initialize
	//
	ready: function()
	{
		var _this = this;
		_this.calendar = $('#ric-calendar-' + _this.hash);

		_this.calendar.fullCalendar(
			$.extend({
				header: {
						left: 'prev,next today',
						center: 'title',
						right: 'month,agendaWeek,agendaDay,listWeek'
				},
				//height: "auto",
				aspectRatio: 2, // smaller cells in month view
				navLinks: true, // can click day/week names to navigate views
				editable: false, // Would be overriden in editable events
				eventLimit: true, // allow "more" link when too many events
				events: _this.options.url, // data source
				scrollTime: "8:00:00", // Where to start showing calendar in agenda
				timeFormat: "H:mm", // Show 8:00 instead of 8

				eventDragStart: function(event, delta, revertFunc) {
					event.oldStart = event.start;
					event.oldEnd = event.end;
					event.oldAllDay = event.allDay;
				},

				eventResizeStart: function(event, delta, revertFunc) {
					event.oldStart = event.start;
					event.oldEnd = event.end;
					event.oldAllDay = event.allDay;
				},

				eventDrop: function(event, delta, revertFunc) {
					_this.moveEvent(event, delta, revertFunc);
				},

				eventResize: function(event, delta, revertFunc) {
					_this.moveEvent(event, delta, revertFunc);
				},

				viewRender: function(view, element) {
					if (!_this._ignoreViewRenderCallback) {
						_this.saveView(view);
					}
					else {
						_this._ignoreViewRenderCallback = false;
					}
				},

				dayClick: function(date, event, view) {
					// Create new event on click in calendar white space
					if (_this.options.newUrl !== undefined) {
						if (_this.options.newUrl.includes('?')) {
							delimiter = '&'
						} else {
							delimiter = '?'
						}
						window.location.href = _this.options.newUrl + delimiter + 'date=' + date.format();
					}
				},

				eventRender: function(event, element) {
					if (event.isRecurring) {
						element.find('.fc-title').prepend(" ").prepend($('<i class="fa fa-refresh" aria-hidden="true"></i>'));
					}
				},



			}, _this.loadState())
		);
	},

	//
	// Save calendar state
	//
	// view ... fullcalendar View Object
	//
	saveView: function(view)
	{
		var serializedView = JSON.stringify({
			name: view.name,
			start: view.start,
			end: view.end,
			intervalStart: view.intervalStart,
			intervalEnd: view.intervalEnd,
		});

		localStorage.setItem(this._localStorageKey, serializedView);
	},

	//
	// Load calendar state
	//
	// Returns subset of fullcalendar View Object
	//
	loadView: function()
	{
		var serializedView = localStorage.getItem(this._localStorageKey);
		return serializedView !== null ? JSON.parse(serializedView) : null;
	},

	//
	// Get saved view name
	//
	loadState: function()
	{
		var settings = {};

		var view = this.loadView();
		if (view !== null) {
			settings.defaultView = view.name;
			settings.defaultDate = view.intervalStart; // Interval start respects correct month in month view
		}

		return settings;
	}

}

