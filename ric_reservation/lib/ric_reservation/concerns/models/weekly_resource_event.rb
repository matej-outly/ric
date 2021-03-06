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

				included do

					before_validation :set_dates_for_weekly_resources

					# *********************************************************
					# Virtual attribute for day of week setting
					# *********************************************************

					attr_writer :day_of_week
					enum_column :day_of_week, [
						{ value: "monday", label: I18n.t("date.days.monday") }, 
						{ value: "tuesday", label: I18n.t("date.days.tuesday") }, 
						{ value: "wednesday", label: I18n.t("date.days.wednesday") }, 
						{ value: "thursday", label: I18n.t("date.days.thursday") }, 
						{ value: "friday", label: I18n.t("date.days.friday") }, 
						{ value: "saturday", label: I18n.t("date.days.saturday") }, 
						{ value: "sunday", label: I18n.t("date.days.sunday") }
					]

				end

				def day_of_week
					if @day_of_week.nil? && !self.date_from.blank? # Compute day of week from date_from if day_of_week not available
						@day_of_week = self.class.available_day_of_weeks[self.date_from.cwday - 1].value
					end
					return @day_of_week
				end

				def time_formatted
					if self.resource.period == "week"
						result = ""
						result += I18n.t("date.days.#{self.day_of_week}") + " " if !self.day_of_week.blank?
						result += self.time_from.strftime(I18n.t("time.formats.hour_min")) if !self.time_from.blank?
						return result
					else
						return super
					end
				end

			protected

				def set_dates_for_weekly_resources
					if self.resource.period == "week"

						cwday = nil
						
						if !self.day_of_week.blank?
							idx = self.class.available_day_of_weeks.index { |obj| obj.value == self.day_of_week }
							if !idx.nil?
								cwday = idx + 1
							end
						end

						# Set correct date_from and date_to
						self.date_from = self.resource.valid_from.beginning_of_week + (cwday.days - 1) # Monday == 1
						self.date_to = self.date_from

					end
				end

			end
		end
	end
end
