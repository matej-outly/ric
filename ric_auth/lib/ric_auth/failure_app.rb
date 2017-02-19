# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Failure App
# *
# * Author: Matěj Outlý
# * Date  : 19. 2. 2017
# *
# *****************************************************************************

module RicAuth
	class FailureApp < Devise::FailureApp
		include RicAuth.devise_paths_concern

		def redirect_url
			after_inactive_sign_in_path_for(nil)
		end

		# You need to override respond to eliminate recall
		#def respond
		#	if http_auth?
		#		http_auth
		#	else
		#		redirect
		#	end
		#end

	end
end