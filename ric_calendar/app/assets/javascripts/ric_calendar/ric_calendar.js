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
 * - url ... (string) Path to event source (usually `events_calendars_path`)
 * - newUrl .... (string) Path to new event action. Adds `date` as get param to path.
 * - toggleCalendarSelector ... (string) Selector to checkboxes for calendars toggling
 */

function RicCalendar(hash, options)
{
	this.hash = hash;
	this.calendar = null;
	this.options = $.extend({
		url: "/calendars/events",
		toggleCalendarSelector: null,
	}, options);

	// Local storage key
	this._localStorageKey = 'ric_calendar_' + hash;

	// Ignore view render callback during fullcalendar load
	this._ignoreViewRenderCallback = true;

	// Do not show some calendars
	this.disabledCalendarIds = [];
}
RicCalendar.prototype = {
	constructor: RicCalendar,

	//
	// Drag & Drop events editation
	//
	moveEvent: function(event, delta, revertFunc)
	{
		var self = this;

		var datetimeFrom = event.start;
		var datetimeTo = event.end;
		var oldDatetimeFrom = event.oldStart;
		var oldDatetimeTo = event.oldEnd;
		var updateUrl = event.editUrl;

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
			update_action: "onlyself",
		};

		$.post({
			url: updateUrl,
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
		var self = this;

		// Load saved options from local storage
		self.loadOptions();

		// Initialize fullcalendar
		self.calendar = $('#ric-calendar-' + self.hash);
		self.calendar.fullCalendar(
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
				scrollTime: "8:00:00", // Where to start showing calendar in agenda
				timeFormat: "H:mm", // Show 8:00 instead of 8

				events: function(start, end, timezone, callback) {
					$.post({
						url: self.options.url,
						dataType: 'json',
						data: {
							start: start.format("YYYY-MM-DD"),
							end: end.format("YYYY-MM-DD"),
							disabled_calendars: self.disabledCalendarIds,
						},
						success: function(events) {
							callback(events);
						}
					});
				},
				// events: self.options.url,

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
					self.moveEvent(event, delta, revertFunc);
				},

				eventResize: function(event, delta, revertFunc) {
					self.moveEvent(event, delta, revertFunc);
				},

				viewRender: function(view, element) {
					if (!self._ignoreViewRenderCallback) {
						self.saveView(view);
					}
					else {
						self._ignoreViewRenderCallback = false;
					}
				},

				dayClick: function(date, event, view) {
					// Create new event on click in calendar white space
					if (self.options.newUrl !== undefined && self.options.newUrl !== null && self.options.newUrl !== '') {
						if (self.options.newUrl.includes('?')) {
							delimiter = '&'
						} else {
							delimiter = '?'
						}
						window.location.href = self.options.newUrl + delimiter + 'date=' + date.format();
					}
				},

				eventRender: function(event, element) {
					if (event.isRecurring) {
						element.find('.fc-title').prepend(" ").prepend($('<i class="fa fa-refresh" aria-hidden="true"></i>'));
					}
				},



			}, self.loadState())
		);

		// Set up calendars switch
		if (self.options.toggleCalendarSelector !== null) {
			$(self.options.toggleCalendarSelector).each(function() {
				var $checkbox = $(this);
				var calendarId = $checkbox.attr("data-calendar-id");

				// Set up checkboxes
				if (self.disabledCalendarIds && self.disabledCalendarIds.indexOf(calendarId) === -1) {
					$checkbox.attr("checked", true);
				}

			}).click(function() {
				var $checkbox = $(this);
				var calendarId = $checkbox.attr("data-calendar-id");
				var isEnabled = $checkbox.is(":checked");


				var calendarIdIdx = self.disabledCalendarIds.indexOf(calendarId);

				if (isEnabled && calendarIdIdx !== -1) {
					// Enable calendar
					self.disabledCalendarIds.splice(calendarIdIdx, 1);
				}
				if (!isEnabled && calendarIdIdx === -1) {
					// Disable calendar
					self.disabledCalendarIds.push(calendarId);
				}

				// Save state
				self.saveOptions();

				// Reload calendar
				self.calendar.fullCalendar('refetchEvents')
			});
		}
	},

	//
	// Save various calendar settings
	//
	saveOptions: function()
	{
		var serialized = JSON.stringify({
			disabledCalendarIds: this.disabledCalendarIds,
		});

		localStorage.setItem(this._localStorageKey + "_options", serialized);

	},

	//
	// Load various calendar settings
	//
	loadOptions: function()
	{
		var serialized = localStorage.getItem(this._localStorageKey + "_options");
		var options = serialized !== null ? JSON.parse(serialized) : null;
		if (options !== null) {
			this.disabledCalendarIds = options.disabledCalendarIds;
		}
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

		localStorage.setItem(this._localStorageKey + "_view", serializedView);
	},

	//
	// Load calendar state
	//
	// Returns subset of fullcalendar View Object
	//
	loadView: function()
	{
		var serializedView = localStorage.getItem(this._localStorageKey + "_view");
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
	},

	//
	// Get currently visited date
	//
	getDate: function()
	{
		return this.calendar.fullCalendar('getDate');
	},

	//
	// Get currently visited date range
	//
	getDateRange: function()
	{
		var view = this.calendar.fullCalendar('getView').type;
		var date = this.calendar.fullCalendar('getDate');
		if (view == 'month') {
			return [
				moment(date).startOf('month'),
				moment(date).endOf('month'),
			];
		} else if (view == 'basicWeek' || view == 'agendaWeek' || view == 'listWeek') {
			return [
				moment(date).startOf('week'),
				moment(date).endOf('week'),
			];
		} else if (view == 'basicDay' || view == 'agendaDay') {
			return [
				moment(date),
				moment(date),
			];
		} else {
			return null;
		}
	}

}

