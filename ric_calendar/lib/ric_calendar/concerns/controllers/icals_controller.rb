# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Events
# *
# * Author:
# * Date  : 19. 2. 2017
# *
# *****************************************************************************

module RicCalendar
	module Concerns
		module Controllers
			module IcalsController extend ActiveSupport::Concern

				def show
					calendar = RicCalendar.calendar_model.find_by_id(params[:calendar_id])
					user = RicCalendar.user_model.find_by_id(params[:id]) # TODO authentication
					if calendar.nil? || user.nil?
						data = ""
					else
						date_from = Date.today - 1.month # TODO some param ????
						date_to = Date.today + 1.year
						data = calendar.to_ical(user, date_from, date_to)
					end

					# Add calendar header, however it is not neccessary at least for iPhone 4S
					headers['Content-Type'] = "text/calendar; charset=UTF-8"
					render text: data
				end

			end
		end
	end
end