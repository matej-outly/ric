# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Roles
# *
# * Author: Matěj Outlý
# * Date  : 9. 6. 2015
# *
# *****************************************************************************

module RicUser
	module Concerns
		module Controllers
			module RolesController extend ActiveSupport::Concern

				def search
					@roles = RicUser.role_model.search(params[:q]).order(name: :asc)
					respond_to do |format|
						format.html { render "index" }
						format.json { render json: @roles.to_json }
					end
				end

			protected

			end
		end
	end
end
