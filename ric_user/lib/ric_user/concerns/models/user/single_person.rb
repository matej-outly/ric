# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Single-person user
# *
# * Author: Matěj Outlý
# * Date  : 20. 3. 2017
# *
# *****************************************************************************

module RicUser
	module Concerns
		module Models
			module User
				module SinglePerson extend ActiveSupport::Concern

					included do
						
						# *****************************************************
						# Person
						# *****************************************************

						belongs_to :person, polymorphic: true

						# *****************************************************
						# Specific person getters
						# *****************************************************

						if RicUser.person_types
							RicUser.person_types.each do |person_type|
								define_method(person_type.split("::").last.to_snake) do
									if self.person_id && self.person_type == person_type
										return self.person
									else
										return nil
									end
								end
							end
						end

					end

					# TODO Data synchronization

				end
			end
		end
	end
end