# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Model can own some people selectors
# *
# * Author: Matěj Outlý
# * Date  : 11. 4. 2017
# *
# *****************************************************************************

module RicUser
	module Concerns
		module Models
			module PeopleSelectable extend ActiveSupport::Concern

				#
				# 'included do' causes the included code to be evaluated in the
				# context where it is included, rather than being executed in 
				# the module's context.
				#
				included do

					# *********************************************************
					# Structure
					# *********************************************************

					has_many :people_selectors, class_name: RicUser.people_selector_model.to_s, as: :subject, dependent: :destroy

				end

				def people
					if @people.nil?

						# Concat people from all selectors
						@people = []
						self.people_selectors.all.each do |people_selector|
							@people = @people.concat(people_selector.people.to_a)
						end

						# Uniq by class_name and ID
						# TODO ...

						# Sort by name
						if !@people.empty?
							if @people.first.respond_to?(:name_lastname) && @people.first.respond_to?(:name_firstname)
								@people.sort! { |p1, p2| p1.name_lastname <=> p2.name_lastname } # TODO name_firstname
							elsif @people.first.respond_to?(:name_formatted)
								@people.sort! { |p1, p2| p1.name_formatted <=> p2.name_formatted }
							elsif @people.first.respond_to?(:name)
								@people.sort! { |p1, p2| p1.name <=> p2.name }
							end								
						end

					end
					return @people
				end

				# *************************************************************
				# People selector values
				# *************************************************************

				def people_selector_values
					if @people_selector_values.nil?
						@people_selector_values = self.people_selectors.map { |selector| selector.value }
					end
					return @people_selector_values
				end

				def people_selector_values=(new_values)

					# Manage input
					if new_values.blank?
						new_values = []
					else
						new_values = [new_values.to_s] if !new_values.is_a?(Array)
						new_values.uniq!
					end

					# Remove invalid selectors, create new selectors if missing
					self.transaction do
						self.people_selectors.to_a.diff(new_values, compare_attr_1: :value) do |action, item|
							if action == :add
								self.people_selectors.create(value: item)
							elsif action == :remove
								item.destroy
							end
						end
					end

					# Clear cache
					@people_selector_values = nil
					@people = nil
					self.people_selectors.reset

					return new_values
				end

			end
		end
	end
end