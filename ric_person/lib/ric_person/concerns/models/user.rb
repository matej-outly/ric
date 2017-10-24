# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Multi-people user TODO
# *
# * Author: Matěj Outlý
# * Date  : 20. 3. 2017
# *
# *****************************************************************************

module RicPerson
	module Concerns
		module Models
			module User extend ActiveSupport::Concern
			
				included do
					
					# *****************************************************
					# People
					# *****************************************************

					has_many :user_people, class_name: RicUser.user_person_model.to_s, dependent: :destroy

					# *****************************************************
					# Specific person getters
					# *****************************************************

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
				# Get person based on currently selected user role
				#
				def person
					self.current_person
				end

				#
				# Get person based on currently selected user role
				#
				def current_person
					self.people.each do |person|
						if person.person_role == self.role
							return person
						end
					end
					return nil
				end

			end
		end
	end
end
