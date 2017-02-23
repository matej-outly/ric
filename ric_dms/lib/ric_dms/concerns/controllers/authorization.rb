# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Authorization
# *
# * Author:
# * Date  : 23. 2. 2017
# *
# *****************************************************************************

module RicDms
	module Concerns
		module Controllers
			module Authorization extend ActiveSupport::Concern

				included do
					helper_method :can_read?
					helper_method :can_read_and_write?
				end

				def can_read?
					true
				end

				def can_read_and_write?
					true
				end

				def not_autorized!
				end

			end
		end
	end
end