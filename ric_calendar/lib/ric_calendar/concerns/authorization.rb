# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Authorization
# *
# * Author: Jaroslav Mlejnek, Matěj Outlý
# * Date  : 23. 2. 2017
# *
# *****************************************************************************

module RicCalendar
	module Concerns
		module Authorization extend ActiveSupport::Concern

			included do
				helper_method :can_read?
				helper_method :can_read_and_write?
			end

			#
			# To be connected to authorization mechanism in application
			#
			def can_read?
				true
			end

			#
			# To be connected to authorization mechanism in application
			#
			def can_read_and_write?
				true
			end

			#
			# To be connected to authorization mechanism in application
			#
			def not_autorized!
			end

		end
	end
end