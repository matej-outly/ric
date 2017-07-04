# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * User person
# *
# * Author: Matěj Outlý
# * Date  : 20. 3. 2017
# *
# *****************************************************************************

module RicUser
	module Concerns
		module Models
			module UserPerson extend ActiveSupport::Concern

				included do

					# *********************************************************
					# Structure
					# *********************************************************

					belongs_to :user, class_name: RicUser.user_model.to_s
					belongs_to :person, polymorphic: true
					
					# *********************************************************
					# Validators
					# *********************************************************

					validates_presence_of :user_id, :person_id, :person_type

				end

			end
		end
	end
end