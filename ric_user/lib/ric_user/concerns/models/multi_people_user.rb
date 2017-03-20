# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Multi-people user
# *
# * Author: Matěj Outlý
# * Date  : 20. 3. 2017
# *
# *****************************************************************************

module RicUser
	module Concerns
		module Models
			module MultiPeopleUser extend ActiveSupport::Concern

				#
				# 'included do' causes the included code to be evaluated in the
				# context where it is included, rather than being executed in 
				# the module's context.
				#
				included do
					
					# *********************************************************
					# People
					# *********************************************************

					has_many :user_people, class_name: RicUser.user_person_model.to_s

					# *********************************************************
					# Specific person getters
					# *********************************************************

					if RicUser.person_types
						RicUser.person_types.each do |person_type|
							define_method(person_type.split("::").last.to_snake) do
								user_person = self.user_people.where(person_type: person_type).first
								if user_person
									return user_person.person
								else
									return nil
								end
							end
						end
					end

				end

				#
				# Common people getter
				#
				def people
					if @people.nil?
						@people = self.user_people.order(id: :asc).to_a.map { |user_person| user_person.person }
					end
					return @people
				end

				#
				# Common people setter is not necessary
				#

				# TODO Data synchronization

			end
		end
	end
end