module RicReservation
	module TimetablePaginationHelper

		def timetable_pagination(date, period, page, path_callback, options = {})

			# From / to / period / page
			from, to, period, page = RicReservation.event_model.schedule_paginate(date, period, page)

			# Labels
			next_label = options[:next_label] ? options[:next_label] : I18n.t("views.calendar.next_#{period}").upcase_first
			prev_label = options[:prev_label] ? options[:prev_label] : I18n.t("views.calendar.previous_#{period}").upcase_first
			week_label = options[:week_label] ? options[:week_label] : I18n.t("views.calendar.period.week").upcase_first
			month_label = options[:month_label] ? options[:month_label] : I18n.t("views.calendar.period.month").upcase_first
			
			result = ""
			result += "<div class=\"timetable-pagination\">\n"
			result += "	<div class=\"prev\">\n"
			if options[:page_bottom].nil? || page > options[:page_bottom]
				params = {}
				params[:period] = period if period != "week"
				params[:page] = page-1 if page != 2
				result += "		" + link_to("<i class=\"icon-left-open-big\"></i>".html_safe + prev_label, path_callback.call(params)) + "\n"
			end
			result += "	</div>\n"
			result += "	<div class=\"title\">\n"
			
			# Period toggle
			result += "		" + link_to(week_label, path_callback.call({}), class: (period == "week" ? "active" : "")) + "\n"
			result += "		" + link_to(month_label, path_callback.call({period: "month"}), class: (period == "month" ? "active" : "")) + "\n"
			
			result += "		<br/>"
			
			# Date
			result += "		#{I18n.l(from)} - #{I18n.l(to - 1.day)}\n"

			result += "	</div>\n"
			result += "	<div class=\"next\">\n"
			if options[:page_top].nil? || page < options[:page_top]
				params = {}
				params[:period] = period if period != "week"
				params[:page] = page+1 if page != 0
				result += "		" + link_to((next_label + "<i class=\"icon-right-open-big\"></i>").html_safe, path_callback.call(params)) + "\n"
			end
			result += "	</div>\n"
			result += "</div>\n"
			
			return result.html_safe
		end

	end
end