module RicReservation
	module Helpers
		module WeekTimetableHelper
			
			#
			# Get all items in the day 
			#
			def self.week_timetable_find_items_by_day(items, day, min_hour, max_hour)
				result = []
				items.each do |item|
					if item[:day] == day 
						if item[:hour] >= min_hour && item[:hour] <= max_hour
							result << item
						end
					end
				end
				return result
			end

			#
			# Find matching timetable item
			#
			def self.week_timetable_find_item(items, day, hour, row, col)
				items.each do |item|
					if item[:day] == day && item[:hour] == hour && item[:row] == row && item[:col] == col
						return item
					end
				end
				return nil
			end

			#
			# Get all items in the day 
			#
			def self.week_timetable_pop_item(items, day, hour, col)
				result = nil
				result_idx = nil
				items.each_with_index do |item, item_idx|
					if item[:day] == day && item[:hour] == hour && item[:col] == col
						result = item
						result_idx = item_idx
						break
					end
				end
				items.delete_at(result_idx) if !result.nil?
				return result
			end

			#
			# Get item label
			#
			def self.week_timetable_item_label(item)
				if item.respond_to?(:name)
					return item.name
				elsif item.respond_to?(:subject) && item.subject && item.subject.respond_to?(:name)
					return item.subject.name
				else
					return ""
				end
			end

			#
			# Get day label
			#
			def self.week_timetable_day_label(day, date)
				result = ""
				result += "<div class=\"day-of-week\">" + I18n.t("views.calendar.days.#{day}") + "</div>"
				result += "<div class=\"date\">#{I18n.l(date)}</div>"
				return result
			end

			#
			# Get item tooltip
			#
			def self.week_timetable_item_tooltip(item)
				return "#{I18n.l(item.schedule_date)} #{item.schedule_from.strftime("%k:%M")} - #{item.schedule_to.strftime("%k:%M")}"
			end

			#
			# Prepare timetable items
			#
			def self.week_timetable_items(date, data, options = {})

				# Default options
				cols_in_hour = options[:cols_in_hour] ? options[:cols_in_hour] : 2
				label_callback = options[:label_callback] ? options[:label_callback] : method(:week_timetable_item_label)
				tooltip_callback = options[:tooltip_callback] ? options[:tooltip_callback] : method(:week_timetable_item_tooltip)
				path_callback = options[:item_path_callback] ? options[:item_path_callback] : nil

				# Items
				items = []
				minute_step = (60 / cols_in_hour).round # How many minutes are in one column
				data.each do |item|

					if !item.respond_to?(:tmp_canceled?) || !item.tmp_canceled?
					
						from_hour = item.schedule_from.strftime("%k").to_i
						from_minute = item.schedule_from.strftime("%M").to_i

						to_hour = item.schedule_to.strftime("%k").to_i
						to_minute = item.schedule_to.strftime("%M").to_i		

						# Find closest "from" column (in "from" hour)
						from_col = 0
						while (from_col * minute_step) <= from_minute
							from_col += 1
						end
						from_col -= 1

						# Find closest "to" column (in "to" hour)
						to_col = 0
						while (to_col * minute_step) < to_minute
							to_col += 1
						end
						to_col -= 1

						# Width (to end of first hour)    + (whole hours between)                      + (last hour)
						width = (cols_in_hour - from_col) + (cols_in_hour * (to_hour - from_hour - 1)) + (to_col + 1)

						# Tags
						tags = []
						tags << "state-#{item.state.to_s}" if item.respond_to?(:state)
						tags << "color-#{item.color.to_s}" if item.respond_to?(:color)
						tags << "at-capacity" if item.respond_to?(:at_capacity?) && item.at_capacity?

						items << {
							day: item.schedule_from.to_date.cwday - 1,
							hour: from_hour,
							col: from_col,
							width: width,
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
			# Prepare timetable hours
			#
			def self.week_timetable_hours(date, items, options = {})

				# Default options
				cols_in_hour = options[:cols_in_hour] ? options[:cols_in_hour] : 2
				min_hour = options[:min_hour] ? options[:min_hour] : 24
				max_hour = options[:max_hour] ? options[:max_hour] : 0

				# Min/max hour
				items.each do |item|
					min_hour = item[:hour] if item[:hour] < min_hour
					max_hour = item[:hour] if item[:hour] > max_hour
				end

				# Hours
				hours = []
				(min_hour..max_hour).each do |hour|
					hours << {
						hour: hour,
						cols: cols_in_hour
					}
				end

				return [hours, min_hour, max_hour]
			end

			#
			# Prepare timetable days
			#
			def self.week_timetable_days(date, items, hours, min_hour, max_hour, options = {})
				
				# Options
				label_callback = options[:day_label_callback] ? options[:day_label_callback] : method(:week_timetable_day_label)

				# Days
				tmp_date = date.week_monday
				days = []
				["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"].each do |day|
					days << {
						label: label_callback.call(day, tmp_date).html_safe,
						date: tmp_date,
						rows: 0
					}
					tmp_date = tmp_date + 1.day
				end

				# Timetable item to rows
				days.each_with_index do |day, day_idx|
					day_items = week_timetable_find_items_by_day(items, day_idx, min_hour, max_hour)
					row = 0
					while !day_items.empty?
						rest_item_width = 0
						hours.each do |hour|
							(0..(hour[:cols]-1)).each do |col|
								if rest_item_width > 0
									rest_item_width -= 1
								else
									item = week_timetable_pop_item(day_items, day_idx, hour[:hour], col)
									if !item.nil?
										item[:row] = row 
										rest_item_width = item[:width] - 1
									end
								end
							end
						end
						row += 1
					end
					day[:rows] = [row, 1].max
				end

				return days
			end

			#
			# Draw week timetable table
			#
			# Data:
			#  - hours               ... Array of hour descriptors. Hour descriptor is map with keys:
			#                             - hour ... Number of hour.
			#                             - cols ... Number of columns in the hour.
			#  - days                ... Array of day descriptors. Day descriptor is map with keys: 
			#                             - label ... Day label.
			#                             - rows  ... Number of rows is the day
			#  - items               ... Array of data items. Each item is map consisting of keys:
			#                             - day     ... Vertical item position.
			#                             - hour    ... Horizontal item position.
			#                             - row     ... Vertical item position.
			#                             - col     ... Horizontal item position.
			#                             - width   ... Number of elementary columns.
			#                             - label   ... Item label.
			#                             - tags    ... Tags interpreted as CSS classes.
			#                             - path    ... Path for item click.
			#                             - tooltip ... Optional tooltip.
			#
			# Options:
			#  - item_path_callback  ... Path composer for items
			#  - empty_path_callback ... Path composer for empty spaces
			#
			def self.week_timetable_render(items, hours, days, options = {})
				
				result = ""
				result += "<table class=\"week timetable\">\n"
				result += "	<tbody>\n"
				result += "		<tr>\n"
				result += "			<td class=\"header right-solid bottom-solid\"></td>\n"
				hours.each do |hour|
					result += "			<td class=\"header right-solid bottom-solid\" colspan=\"#{hour[:cols]}\">#{hour[:hour]}</td>\n"
				end
				result += "		</tr>\n"
				days.each_with_index do |day, day_idx|
					(0..(day[:rows]-1)).each do |row|
						rest_item_width = 0
						result += "		<tr>\n"
						if row == 0
							result += "			<td class=\"header right-solid bottom-solid\" rowspan=\"#{day[:rows]}\">#{day[:label]}</td>\n"
						end
						hours.each do |hour|
							(0..(hour[:cols]-1)).each do |col|
								if rest_item_width > 0
									# Nothing (replaced by item)
									rest_item_width -= 1
								else
									item = week_timetable_find_item(items, day_idx, hour[:hour], row, col)
									if !item.nil?
										# Item
										result += "			<td class=\"item #{item[:tags]} #{(!item[:tooltip].nil? ? "ttip" : "")}\" #{(!item[:tooltip].nil? ? 'data-tooltip="' + item[:tooltip] + '"' : "").html_safe} colspan=\"#{item[:width]}\">\n"
										url = item[:path_callback] ? item[:path_callback].call(item[:object]) : nil
										if url
											result += "				<a href=\"#{url}\">#{item[:label]}</a>\n"
										else
											result += "				<div class=\"padding\">#{item[:label]}</div>\n"
										end
										result += "			</td>\n"
										rest_item_width = item[:width] - 1
									else
										# Empty
										result += "			<td class=\"empty #{(col == (hour[:cols]-1) ? "right-solid" : "right-dotted")} #{(row == (day[:rows]-1) ? "bottom-solid" : "bottom-invisible")}\">\n"
										if row == 0
											url = (options[:empty_path_callback] ? options[:empty_path_callback].call(day[:date], "#{hour[:hour]}:#{((60/hour[:cols]).to_i * col).to_s.rjust(2, "0")}") : nil)
											if url
												result += "				<a href=\"#{url}\"><i class=\"icon-plus\"></i></a>\n"
											else
												result += "				<div class=\"padding\"></div>\n"
											end
										else
											result += "				<div class=\"padding\"></div>\n"
										end
										result += "			</td>\n"
									end
								end
							end
						end
						result += "		</tr>\n"
					end
				end
				result += "	</tbody>\n"
				result += "</table>\n"

				return result.html_safe
			end

			#
			# Prepare week timetable table for drawing
			#
			def self.week_timetable_prepare(date, data_sources, global_options = {})
				
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
					items.concat(week_timetable_items(date, data, data_options))
				end

				# Hours
				hours, min_hour, max_hour = week_timetable_hours(date, items, global_options)

				# Days
				days = week_timetable_days(date, items, hours, min_hour, max_hour, global_options)

				return [items, hours, days, global_options]
			end

			#
			# Draw week timetable table
			#
			def self.week_timetable(date, data_sources, global_options = {})

				# Prepare
				items, hours, days, global_options = week_timetable_prepare(date, data_sources, global_options)

				# Render
				return week_timetable_render(items, hours, days, global_options)
			end

			# *****************************************************************
			# Interface
			# *****************************************************************

			#
			# Prepare week timetable table for drawing
			#
			def week_timetable_prepare(date, data_sources, global_options = {})
				return self.class.week_timetable_prepare(date, data_sources, global_options)
			end

			#
			# Draw week timetable table
			#
			def week_timetable(date, data_sources, global_options = {})
				return self.class.week_timetable(date, data_sources, global_options)
			end

		end
	end
end