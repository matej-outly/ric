# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Event aimed for resources with "week" period
# *
# * Author: Matěj Outlý
# * Date  : 7. 12. 2015
# *
# *****************************************************************************

module RicReservation
	module Concerns
		module Models
			module WeeklyResourceEvent extend ActiveSupport::Concern

				#
				# 'included do' causes the included code to be evaluated in the
				# context where it is included, rather than being executed in 
				# the module's context.
				#
				included do

					before_validation :set_dates_for_weekly_resources

					# *********************************************************
					# Virtual attribute for day of week setting
					# *********************************************************

					attr_accessor :day_of_week
					enum_column :day_of_week, ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"]

				end

			protected

				def set_dates_for_weekly_resources
					if self.resource.period == "week"

						cwday = nil
						
						if !self.day_of_week.blank?
							idx = self.available_day_of_weeks.index { |obj| obj.value == self.self.day_of_week }
							if !idx.nil?
								cwday = idx + 1
							end
						elsif !self.date_from.blank? # Compute day of week from date_from if day_of_week not available
							cwday = self.date_from.cwday
						end

						# Set correct date_from and date_to
						self.date_from = self.resource.valid_from.week_monday + (cwday.days - 1) # Monday == 1
						self.date_to = self.date_from

					end
				end

			end
		end
	end
end
