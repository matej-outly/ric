# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Sessions
# *
# * Author: Matěj Outlý
# * Date  : 12. 11. 2015
# *
# *****************************************************************************

module RicAuthAdmin
	module Concerns
		module Controllers
			module SessionsController extend ActiveSupport::Concern

				def destroy
					if current_user && current_user.respond_to?(:authentications)
						current_user.authentications.destroy_all
					end
					super
				end
				
			end
		end
	end
end
