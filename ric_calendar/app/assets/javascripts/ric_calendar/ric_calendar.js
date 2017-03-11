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
}
RicCalendar.prototype = {
	constructor: RicCalendar,
	moveEvent: function(id, start, end, editUrl, revertFunc) 
	{
		var calendarEvent = {};
		var startDate = (start ? start.format("YYYY-MM-DD") : null);
		var startTime = (start && start.hasTime() ? start.format("HH:mm:ss") : null);
		var endDate = (end ? end.format("YYYY-MM-DD") : startDate);
		var endTime = (end && end.hasTime() ? end.format("HH:mm:ss") : startTime);

		if (start.hasTime()) {
			// Move to another time
			calendarEvent = {
				all_day: false,
				start_date: startDate,
				start_time: startTime,
				end_date: endDate,
				end_time: endTime,
			};
		} else {
			// Move to all day activity
			calendarEvent = {
				all_day: true,
				start_date: startDate,
				start_time: startTime,
				end_date: endDate,
				end_time: endTime,
			};
		}

		$.post({
			url: editUrl,
			data: {
				event: calendarEvent,
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
	ready: function() 
	{
		var _this = this;
		_this.calendar = $('#ric-calendar-' + _this.hash);

		_this.calendar.fullCalendar({
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
			}
		});
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