# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Exceptions
# *
# * Author: Matěj Outlý
# * Date  : 7. 7. 2017
# *
# *****************************************************************************

module RicException
	module Concerns
		module Controllers
			module ExceptionsController extend ActiveSupport::Concern

				def not_found
					render :status => 404
				end

				def unacceptable
					render :status => 422
				end

				def internal_error
					render :status => 500
				end
				
			end
		end
	end
end
