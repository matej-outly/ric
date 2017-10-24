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

module RicPerson
	module Concerns
		module Controllers
			module PeopleSelectorsController extend ActiveSupport::Concern

				def search
					render json: RicPerson.people_selector_model.search(params[:q]).to_json
				end

			end
		end
	end
end