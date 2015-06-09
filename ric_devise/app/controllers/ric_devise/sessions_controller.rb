class RicDevise::SessionsController < Devise::SessionsController
	
	#
	# Layout
	#
	layout "ric_admin"

private

	#
	# Must be overriden, not working inside RIC engine
	#
	def after_sign_out_path_for(resource_or_scope)
		main_app.root_path
	end

end
