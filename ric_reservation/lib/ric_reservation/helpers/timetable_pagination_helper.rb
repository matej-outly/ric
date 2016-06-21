module RicReservation
	module Helpers
		module TimetablePaginationHelper

			# *****************************************************************
			# Interface
			# *****************************************************************

			#
			# Draw pagination for timetable
			#
			def timetable_pagination(date, period, page, path_callback, options = {})
				
				# From / to / period / page
				from, to, period, page = RicReservation.event_model.schedule_paginate(date, period, page)

				# Labels
				next_label = options[:next_label] ? options[:next_label] : I18n.t("views.calendar.next_#{period}").upcase_first
				prev_label = options[:prev_label] ? options[:prev_label] : I18n.t("views.calendar.previous_#{period}").upcase_first
				week_label = options[:week_label] ? options[:week_label] : I18n.t("views.calendar.period.week").upcase_first
				month_label = options[:month_label] ? options[:month_label] : I18n.t("views.calendar.period.month").upcase_first
				
				result = ""
				
				# Wrapper
				result += "<div class=\"timetable-pagination\">\n"
				
				# Previous
				result += "	<div class=\"prev\">\n"
				if options[:page_bottom].nil? || page > options[:page_bottom]
					params = {}
					params[:period] = period if period != "week"
					params[:page] = page-1 if page != 2
					result += "		" + link_to("<span class=\"glyphicon glyphicon-menu-left\" aria-hidden=\"true\"></span> ".html_safe + prev_label, path_callback.call(params), class: "btn btn-default btn-sm") + "\n"
				end
				result += "	</div>\n"

				# Middle
				result += "	<div class=\"middle\">\n"
				
				# Period toggle
				result += "		<div class=\"btn-group btn-group-sm\">"
				result += "		" + link_to(week_label, path_callback.call({}), class: "btn btn-default " + (period == "week" ? "active" : "")) + "\n"
				result += "		" + link_to(month_label, path_callback.call({period: "month"}), class: "btn btn-default " + (period == "month" ? "active" : "")) + "\n"
				result += "		</div><br/>"
				
				# Date
				result += "		<span class=\"label label-default\">#{I18n.l(from)} - #{I18n.l(to - 1.day)}</label>\n"

				# Middle
				result += "	</div>\n"

				# Next
				result += "	<div class=\"next\">\n"
				if options[:page_top].nil? || page < options[:page_top]
					params = {}
					params[:period] = period if period != "week"
					params[:page] = page+1 if page != 0
					result += "		" + link_to((next_label + " <span class=\"glyphicon glyphicon-menu-right\" aria-hidden=\"true\"></span>").html_safe, path_callback.call(params), class: "btn btn-default btn-sm") + "\n"
				end
				result += "	</div>\n"

				# Wrapper
				result += "</div>\n"
				
				return result.html_safe
			end

		end
	end
end