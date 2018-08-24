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

module RicPerson
	module Concerns
		module Models
			module User extend ActiveSupport::Concern
			
				included do
					
					# *********************************************************
					# Specific person getters
					# *********************************************************

					if RicPerson.person_types
						RicPerson.person_types.each do |person_type|

							# Plural getter
							define_method(person_type.split("::").last.pluralize.to_snake) do
								name = person_type.split("::").last.pluralize.to_snake
								value = self.instance_variable_get("@#{name}")
								if value.nil? && !self.new_record?
									klass = person_type.constantize rescue nil
									if klass
										value = klass.where(user_id: self.id).order(id: :asc)
										self.instance_variable_set("@#{name}", value)
									end
								end
								return value
							end

							# Singular getter
							define_method(person_type.split("::").last.singularize.to_snake) do
								name = person_type.split("::").last.singularize.to_snake
								value = self.instance_variable_get("@#{name}")
								if value.nil? && !self.new_record?
									klass = person_type.constantize rescue nil
									if klass
										value = klass.where(user_id: self.id).order(id: :asc).first
										self.instance_variable_set("@#{name}", value)
									end
								end
								return value
							end

						end
					end

				end

				# *************************************************************
				# Common person getters
				# *************************************************************

				#
				# Common people (plural) getter
				#
				def people
					if @people.nil? && !self.new_record? && RicPerson.person_types
						@people = []
						RicPerson.person_types.each do |person_type|
							klass = person_type.constantize rescue nil
							if klass
								@people += klass.where(user_id: self.id).order(id: :asc).to_a
							end
						end
					end
					return @people
				end

				#
				# Common person (singular) getter
				#
				def person
					if @person.nil?
						@person = self.people.first
					end
					return @person
				end

			end
		end
	end
end
