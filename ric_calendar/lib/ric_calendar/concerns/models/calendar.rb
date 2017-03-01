# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Calendar Data model
# *
# * Author:
# * Date  : 19. 2. 2017
# *
# *****************************************************************************

module RicCalendar
	module Concerns
		module Models
			module Calendar extend ActiveSupport::Concern

				included do

				end

				module ClassMethods

					# *************************************************************************
					# Columns
					# *************************************************************************

					#
					# Get all columns permitted for editation
					#
					def permitted_columns
						[
							:title,
							:description,
						]
					end

				end

				#
				# Load events for this calendar
				#
				def events
					# TODO: Add some security, such as: Constantize only allowed classes
					klass = self.model.constantize

					if klass.column_names.include?("calendar_id")
						klass.where(calendar_id: self.id)
					else
						return klass
					end
				end

			end
		end
	end
end