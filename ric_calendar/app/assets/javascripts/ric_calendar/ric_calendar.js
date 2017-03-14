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
	moveEvent: function(id, datetimeFrom, datetimeTo, editUrl, revertFunc)
	{
		var event = {};
		var dateFrom = (datetimeFrom ? datetimeFrom.format("YYYY-MM-DD") : null);
		var timeFrom = (datetimeFrom && datetimeFrom.hasTime() ? datetimeFrom.format("HH:mm:ss") : null);
		var dateTo = (datetimeTo ? datetimeTo.format("YYYY-MM-DD") : dateFrom);
		var timeTo = (datetimeTo && datetimeTo.hasTime() ? datetimeTo.format("HH:mm:ss") : timeFrom);

		if (datetimeFrom.hasTime()) {
			// Move to another time
			event = {
				all_day: false,
				date_from: dateFrom,
				time_from: timeFrom,
				date_to: dateTo,
				time_to: timeTo,
			};
		} else {
			// Move to all day activity
			event = {
				all_day: true,
				date_from: dateFrom,
				time_from: timeFrom,
				date_to: dateTo,
				time_to: timeTo,
			};
		}

		$.post({
			url: editUrl,
			data: {
				event: event,
				_method: "PATCH",
			},
			dataType: 'json',
			success: function() {
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

				eventDrop: function(event, delta, revertFunc) {
					_this.moveEvent(event.objectId, event.start, event.end, event.editUrl, revertFunc);
				},

				eventResize: function(event, delta, revertFunc) {
					_this.moveEvent(event.objectId, event.start, event.end, event.editUrl, revertFunc);
				},

				viewRender: function(view, element) {
					if (!_this._ignoreViewRenderCallback) {
						_this.saveView(view);
					}
					else {
						_this._ignoreViewRenderCallback = false;
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

// ???
$.fn.recurring_select.texts = {
	locale_iso_code: "cs",
	repeat: "Opakování",
	last_day: "Poslední den",
	frequency: "Četnost",
	daily: "Denně",
	weekly: "Týdně",
	monthly: "Měsíčně",
	yearly: "Ročně",
	every: "Každý",
	days: ". den/dny",
	weeks_on: ". týden/týdny v ",
	months: ". měsíc/měsíce",
	years: ". rok/roky",
	day_of_month: "Den v měsíci",
	day_of_week: "Den v týdnu",
	ok: "OK",
	cancel: "Zpět",
	summary: "Souhrn",
	first_day_of_week: 1,
	days_first_letter: ["Ne", "Po", "Út", "St", "Čt", "Pá", "So" ],
	order: ["1.", "2.", "3.", "4.", "5.", "Poslední"],
}