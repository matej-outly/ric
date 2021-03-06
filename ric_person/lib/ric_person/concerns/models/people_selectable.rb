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

module RicPerson
	module Concerns
		module Models
			module PeopleSelectable extend ActiveSupport::Concern

				included do

					# *********************************************************
					# Structure
					# *********************************************************

					has_many :people_selectors, class_name: RicPerson.people_selector_model.to_s, as: :subject, dependent: :destroy

					# *********************************************************
					# People selector values
					# *********************************************************

					after_save :update_people_selectors

				end

				def people(options = {})
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

					# Store for later update
					#@people_selector_values_was = self.people_selector_values if @people_selector_values_was.nil?
					@people_selector_values_changed = true
					@people_selector_values = new_values
				end

				#
				# People selectors override to ensure correct results if values
				# manually set but not saved yet.
				#
				def people_selectors(force_old = false)
					if @people_selector_values_changed == true && force_old == false
						if @people_selector_values.nil?
							return nil
						else
							return @people_selector_values.map do |value| 
								OpenStruct.new(
									value: value,
									title: RicPerson.people_selector_model.title(value)
								)
							end
						end
					else
						super
					end
				end

			protected

				def update_people_selectors
					if @people_selector_values_changed == true
						
						# Remove invalid selectors, create new selectors if missing
						self.transaction do
							self.people_selectors(true).diff(@people_selector_values, compare_attr_1: :value) do |action, item|
								if action == :add
									self.people_selectors(true).create(value: item)
								elsif action == :remove
									item.destroy
								end
							end
						end

						# Clear cache
						@people_selector_values = nil
						@people_selector_values_changed = nil
						@people = nil
						self.people_selectors(true).reset
					end
					return true
				end

			end
		end
	end
end