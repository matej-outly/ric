module RicReservation
	module WeekTimetableHelper
		
		#
		# Get all items in the day 
		#
		def week_timetable_day_items(items, day, min_hour, max_hour)
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
		# Get all items in the day 
		#
		def week_timetable_pop_item(items, day, hour, col)
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
		# Find matching timetable item
		#
		def week_timetable_find_item(items, day, hour, row, col)
			items.each do |item|
				if item[:day] == day && item[:hour] == hour && item[:row] == row && item[:col] == col
					return item
				end
			end
			return nil
		end

		#
		# Prepare timetable days
		#
		def week_timetable_days(monday)
			date = monday
			result = []
			["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"].each do |day|
				label = "<div class=\"day-of-week\">" + I18n.t("views.calendar.days.#{day}") + "</div>"
				label += "<div class=\"date\">#{I18n.l(date)}</div>"
				result << {
					label: label.html_safe,
					rows: 0
				}
				date = date + 1.day
			end
			return result
		end
		
		#
		# Prepare timetable items
		#
		def week_timetable_items(date, events, path_callback, cols_in_hour = 2, min_hour = 24, max_hour = 0)

			# Get monday
			monday = date.week_monday

			# Items
			items = []
			minute_step = (60 / cols_in_hour).round # How many minutes are in one column
			events.each do |event|

				if !event.tmp_canceled?
				
					from_hour = event.schedule_from.strftime("%k").to_i
					from_minute = event.schedule_from.strftime("%M").to_i

					to_hour = event.schedule_to.strftime("%k").to_i
					to_minute = event.schedule_to.strftime("%M").to_i		

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

					# Reservations count
					reservations_count = event.reservations.above_line.count

					# Label
					label = "<div class=\"event\">#{event.name}</div>"
					label += "<div class=\"capacity\">#{reservations_count}/#{event.capacity.to_s}</div>"

					# Tags
					tags = []
					tags << "state-#{event.state.to_s}" 
					tags << "at-capacity" if event.at_capacity?

					# Path
					path = path_callback.call(event)

					# Tooltip
					tooltip = "#{I18n.l(event.schedule_date)} #{event.schedule_from.strftime("%k:%M")} - #{event.schedule_to.strftime("%k:%M")}"

					items << {
						day: event.schedule_from.cwday - 1,
						hour: from_hour,
						col: from_col,
						width: width,
						label: label.html_safe,
						tags: tags.join(" "),
						path: path,
						tooltip: tooltip,
					}

				end

			end

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

			# Days
			days = week_timetable_days(monday)

			# Timetable item to rows
			days.each_with_index do |day, day_idx|
				day_items = week_timetable_day_items(items, day_idx, min_hour, max_hour)
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

			return [items, days, hours]
		end

	end
end