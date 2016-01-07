module RicReservation
	module MonthTimetableHelper
		
		#
		# Get all items in the day 
		#
		def month_timetable_find_items_by_day(items, week, day)
			result = []
			items.each do |item|
				if item[:week] == week && item[:day] == day 
					result << item
				end
			end
			return result
		end

		#
		# Find matching timetable item
		#
		def month_timetable_find_item(items, week, day, row)
			items.each do |item|
				if item[:week] == week && item[:day] == day && item[:row] == row
					return item
				end
			end
			return nil
		end

		#
		# Get item label
		#
		def month_timetable_item_label(item)
			if item.respond_to?(:name)
				return item.name
			elsif item.respond_to?(:subject) && item.subject && item.subject.respond_to?(:name)
				return item.subject.name
			else
				return ""
			end
		end

		#
		# Get item tooltip
		#
		def month_timetable_item_tooltip(item)
			return "#{I18n.l(item.schedule_date)} #{item.schedule_from.strftime("%k:%M")} - #{item.schedule_to.strftime("%k:%M")}"
		end

		#
		# Prepare timetable items
		#
		def month_timetable_items(date, data, options = {})
			
			# Default options
			label_callback = options[:label_callback] ? options[:label_callback] : method(:month_timetable_item_label)
			tooltip_callback = options[:tooltip_callback] ? options[:tooltip_callback] : method(:month_timetable_item_tooltip)
			path_callback = options[:item_path_callback] ? options[:item_path_callback] : nil

			# Get monday
			first_this_month = date.beginning_of_month
			first_monday = first_this_month.week_monday

			# Items
			items = []
			data.each do |item|

				if !item.respond_to?(:tmp_canceled?) || !item.tmp_canceled?
					
					# Tags
					tags = []
					tags << "state-#{item.state.to_s}" 
					tags << "at-capacity" if item.respond_to?(:at_capacity?) && item.at_capacity?

					items << {
						week: ((item.schedule_from.to_date - first_monday) / 7).to_i,
						day: item.schedule_from.to_date.cwday - 1,
						label: label_callback.call(item).html_safe,
						tags: tags.join(" "),
						tooltip: tooltip_callback.call(item),
						path_callback: path_callback,
						object: item
					}

				end

			end

			return items
		end
	
		#
		# Prepare timetable days
		#
		def month_timetable_days(date, items, options = {})
			days = []
			["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"].each do |day|
				label = "<div class=\"day-of-week\">" + I18n.t("views.calendar.days.#{day}") + "</div>"
				days << {
					label: label.html_safe,
				}
			end
			return days
		end

		#
		# Prepare timetable weeks
		#
		def month_timetable_weeks(date, items, days, options = {})

			# Dates
			first_this_month = date.beginning_of_month
			first_monday = first_this_month.week_monday
			first_next_month = first_this_month + 1.month
			
			# Weeks
			tmp_date = first_monday
			weeks = []
			while tmp_date < first_next_month do
				label = "<div class=\"week-of-year\">" + I18n.t("views.calendar.week", week: tmp_date.cweek) + "</div>"
				label += "<div class=\"date\">#{I18n.l(tmp_date)} - #{I18n.l(tmp_date + 1.week - 1.day)}</div>"
				weeks << {
					label: label.html_safe,
					date: tmp_date
				}
				tmp_date = tmp_date + 1.week
			end

			# Timetable item to rows
			weeks.each_with_index do |week, week_idx|
				max_row = 0
				days.each_with_index do |day, day_idx|
					day_items = month_timetable_find_items_by_day(items, week_idx, day_idx)
					day_items.each_with_index do |item, row|
						item[:row] = row
						if row > max_row
							max_row = row
						end
					end
				end
				week[:rows] = max_row + 1
			end

			return weeks
		end

		#
		# Draw month timetable table
		#
		# Data:
		#  - days                ... Array of day descriptors. Day descriptor is map with keys: 
		#                             - label ... Day label.
		#  - weeks               ... Array of week descriptors. Week descriptor is map with keys:
		#                             - label ... Week label.
		#                             - rows  ... Number of columns in the week.
		#                             - date  ... First day in week
		#  - items               ... Array of data items. Each item is map consisting of keys:
		#                             - week    ... Vertical item position.
		#                             - day     ... Horizontal item position.
		#                             - row     ... Vertical item position.
		#                             - label   ... Item label.
		#                             - tags    ... Tags interpreted as CSS classes.
		#                             - path    ... Path for item click.
		#                             - tooltip ... Optional tooltip.
		#
		# Options:
		#  - item_path_callback  ... Path composer for items
		#  - empty_path_callback ... Path composer for empty spaces
		#
		def month_timetable_render(items, days, weeks, options = {})
			
			result = ""
			result += "<table class=\"month timetable\">\n"
			result += "	<tbody>\n"
			result += "		<tr>\n"
			result += "			<td class=\"header right-solid bottom-solid\"></td>\n"
			days.each do |day|
				result += "			<td class=\"header right-solid bottom-solid\" colspan=\"1\">#{day[:label]}</td>\n"
			end
			result += "		</tr>\n"
			weeks.each_with_index do |week, week_idx|
				(0..(week[:rows]-1)).each do |row|
					result += "		<tr>\n"
					if row == 0
						result += "			<td class=\"header right-solid bottom-solid\" rowspan=\"#{week[:rows]}\">#{week[:label]}</td>\n"
					end
					date = week[:date]
					days.each_with_index.each do |day, day_idx|
						item = month_timetable_find_item(items, week_idx, day_idx, row)
						if !item.nil?
							# Item
							result += "			<td class=\"item #{item[:tags]}\" colspan=\"1\">\n"
							if row == 0
								if options[:empty_path_callback]
									result += "				<a class=\"title\" href=\"#{options[:empty_path_callback].call(date)}\">#{date.strftime("%-d") + "."}<i class=\"icon-plus\"></i></a>\n"
								else
									result += "				<div class=\"title\">#{date.strftime("%-d") + "."}</div>\n"
								end
							end
							if item[:path_callback]
								result += "				<a class=\"#{(!item[:tooltip].nil? ? "ttip" : "")}\" href=\"#{item[:path_callback].call(item[:object])}\" #{(!item[:tooltip].nil? ? 'data-tooltip="' + item[:tooltip] + '"' : "").html_safe}>#{item[:label]}</a>\n"
							else
								result += "				<div class=\"padding #{(!item[:tooltip].nil? ? "ttip" : "")}\" #{(!item[:tooltip].nil? ? 'data-tooltip="' + item[:tooltip] + '"' : "").html_safe}>#{item[:label]}</div>\n"
							end
							result += "			</td>\n"
						else
							# Empty
							result += "			<td class=\"empty right-solid #{(row == (week[:rows]-1) ? "bottom-solid" : "bottom-invisible")}\">\n"
							if row == 0
								if options[:empty_path_callback]
									result += "				<a class=\"title\" href=\"#{options[:empty_path_callback].call(date)}\">#{date.strftime("%-d") + "."}<i class=\"icon-plus\"></i></a>\n"
								else
									result += "				<div class=\"title\">#{date.strftime("%-d") + "."}</div>\n"
								end
							else
								result += "				<div class=\"padding\"></div>\n"
							end
							result += "			</td>\n"
						end
						date = date + 1.day
					end
					result += "				</tr>\n"
				end
			end
			result += "	</tbody>\n"
			result += "</table>\n"

			return result.html_safe
		end

		#
		# Draw month timetable table
		#
		def month_timetable(date, data_sources, global_options = {})
			
			# Normalize data sources
			data_sources = [data_sources] if !data_sources.is_a?(Array)

			# Items
			items = []
			data_sources.each do |data_source|
				if data_source.is_a?(Array)
					if data_source.length != 2
						raise "Array containing data and data_options expected."
					end
					data = data_source[0]
					data_options = global_options.merge(data_source[1])
				else
					data = data_source
					data_options = global_options
				end
				items.concat(month_timetable_items(date, data, data_options))
			end

			# Days
			days = month_timetable_days(date, items, global_options)

			# Weeks
			weeks = month_timetable_weeks(date, items, days, global_options)

			# Render
			return month_timetable_render(items, days, weeks, global_options)
		end

	end
end