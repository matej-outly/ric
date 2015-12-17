module RicReservation
	module MonthTimetableHelper
		
		#
		# Get all items in the day 
		#
		def month_timetable_day_items(items, week, day)
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
		# Prepare timetable days
		#
		def month_timetable_days
			result = []
			["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"].each do |day|
				label = "<div class=\"day-of-week\">" + I18n.t("views.calendar.days.#{day}") + "</div>"
				result << {
					label: label.html_safe,
				}
			end
			return result
		end

		#
		# Prepare timetable days
		#
		def month_timetable_weeks(first_this_month)
			first_monday = first_this_month.week_monday
			first_next_month = first_this_month + 1.month
			date = first_monday
			result = []
			while date < first_next_month do
				label = "<div class=\"week-of-year\">" + I18n.t("views.calendar.week", week: date.cweek) + "</div>"
				label += "<div class=\"date\">#{I18n.l(date)} - #{I18n.l(date + 1.week - 1.day)}</div>"
				result << {
					label: label.html_safe,
					date: date
				}
				date = date + 1.week
			end
			return result
		end
		
		#
		# Prepare timetable items
		#
		def month_timetable_items(date, events, path_callback)
			
			# Get monday
			first_this_month = date.beginning_of_month
			first_monday = first_this_month.week_monday

			# Items
			items = []
			events.each do |event|

				if !event.tmp_canceled?
					
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
						week: ((event.schedule_from.to_date - first_monday) / 7).to_i,
						day: event.schedule_from.cwday - 1,
						label: label.html_safe,
						tags: tags.join(" "),
						path: path,
						tooltip: tooltip,
					}

				end

			end

			# Days
			days = month_timetable_days

			# Weeks
			weeks = month_timetable_weeks(first_this_month)

			# Timetable item to rows
			weeks.each_with_index do |week, week_idx|
				max_row = 0
				days.each_with_index do |day, day_idx|
					day_items = month_timetable_day_items(items, week_idx, day_idx)
					day_items.each_with_index do |item, row|
						item[:row] = row
						if row > max_row
							max_row = row
						end
					end
				end
				week[:rows] = max_row + 1
			end

			return [items, weeks, days]
		end

	end
end