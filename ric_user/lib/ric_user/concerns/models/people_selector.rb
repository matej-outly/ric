# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * People selector
# *
# * Author: Matěj Outlý
# * Date  : 11. 4. 2017
# *
# *****************************************************************************

module RicUser
	module Concerns
		module Models
			module PeopleSelector extend ActiveSupport::Concern

				#
				# 'included do' causes the included code to be evaluated in the
				# context where it is included, rather than being executed in 
				# the module's context.
				#
				included do

					# *********************************************************
					# Structure
					# *********************************************************

					belongs_to :subject, polymorphic: true

					# *********************************************************
					# Validators
					# *********************************************************

					validates_presence_of :key
					#validates_presence_of :subject_id, :subject_type

					# *********************************************************
					# Title
					# *********************************************************

					before_save :update_title

				end

				module ClassMethods

					# *********************************************************
					# Definition af available selectors
					# *********************************************************

					#
					# Define new selector with select, search and title functions
					#
					def define_selector(key, callbacks)
						raise "Please define select callback." if !callbacks[:select].is_a?(Proc)
						raise "Please define search callback." if !callbacks[:search].is_a?(Proc)
						raise "Please define title callback." if !callbacks[:title].is_a?(Proc)
						self.available_selectors[key.to_sym] = callbacks
					end

					def available_selectors
						@available_selectors = {} if @available_selectors.nil?
						return @available_selectors
					end

					# *********************************************************
					# Search in available selectors
					# *********************************************************

					#
					# Return possible parametrized selectors based on a query
					#
					def search(query)
						result = []
						if !query.blank?
							self.available_selectors.each do |selector_key, selector_def|
								selector_def[:search].call(query.to_s).each do |found_params|
									result << {
										value: "#{selector_key}/#{found_params.to_json}",
										title: selector_def[:title].call(found_params)
									}
								end
							end
						end
						return result
					end

				end

				# *************************************************************
				# Value
				# *************************************************************

				def value
					"#{self.key}/#{read_attribute(:params)}"
				end

				def value=(value)
					splitted = value.split("/") # Parse value to key and params
					self.key = splitted.shift
					self.params = (splitted.empty? ? nil : splitted.join("/"))
				end

				# *************************************************************
				# Params
				# *************************************************************

				def params
					if read_attribute(:params) == "null"
						return nil
					else
						return JSON.parse(read_attribute(:params)).symbolize_keys
					end
				end

				def params=(val)
					val = val.to_json if !val.is_a?(String)
					write_attribute(:params, val)
				end

				# *************************************************************
				# People
				# *************************************************************

				#
				# Get all people selected by this selector
				#
				def people
					if @people.nil?
						@people = self._people
					end
					return @people
				end

			protected

				def _people
					selector_def = self.class.available_selectors[self.key.to_sym]
					if selector_def && selector_def[:select]
						return selector_def[:select].call(self.params)
					else
						raise "Unknown selector."
					end
				end

				def _title
					selector_def = self.class.available_selectors[self.key.to_sym]
					if selector_def && selector_def[:title]
						return selector_def[:title].call(self.params)
					else
						raise "Unknown selector."
					end
				end

				def update_title
					self.title = self._title
				end

			end
		end
	end
end