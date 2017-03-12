# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Colored
# *
# * Author: Matěj Outlý
# * Date  : 19. 2. 2017
# *
# *****************************************************************************

module RicCalendar
	module Concerns
		module Models
			module Colored extend ActiveSupport::Concern

				included do

					# *********************************************************
					# Colors
					# *********************************************************

					# Enum
					enum_column :color, config(:colors).keys

				end

				module ClassMethods
					
					# *********************************************************
					# Columns
					# *********************************************************

					#
					# Get all columns permitted for editation
					#
					def permitted_columns_for_colored
						[
							:color,
						]
					end

				end

				# *************************************************************
				# Color
				# *************************************************************

				def color_primary
					if self.color && config(:colors)[self.color.to_sym]
						config(:colors)[self.color.to_sym][:primary]
					end
				end

				def color_faded
					if self.color && config(:colors)[self.color.to_sym]
						config(:colors)[self.color.to_sym][:faded]
					end
				end

				def color_text
					if self.color && config(:colors)[self.color.to_sym]
						config(:colors)[self.color.to_sym][:text]
					end
				end

			end

		end
	end
end