# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Abstract engine controller
# *
# * Author: Matěj Outlý
# * Date  : 22. 10. 2015
# *
# *****************************************************************************

module RicEshop
	class PublicController < ::ApplicationController

	protected
	
		#
		# Get valid session ID
		#
		def session_id
			if session.id.nil?
				session[:tmp] = "tmp"
				session.delete(:tmp)
			end
			return session.id
		end

	end
end
