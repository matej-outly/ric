# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * People selectors
# *
# * Author: Matěj Outlý
# * Date  : 11. 4. 2017
# *
# *****************************************************************************

module RicUser
	module Concerns
		module Controllers
			module Admin
				module PeopleSelectorsController extend ActiveSupport::Concern

					def search
						render json: RicUser.people_selector_model.search(params[:q]).to_json
					end

				end
			end
		end
	end
end