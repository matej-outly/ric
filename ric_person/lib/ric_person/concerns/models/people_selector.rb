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

module RicPerson
	module Concerns
		module Models
			module PeopleSelector extend ActiveSupport::Concern

				included do

					# *********************************************************
					# Structure
					# *********************************************************

					belongs_to :subject, polymorphic: true

					# *********************************************************
					# Validators
					# *********************************************************

					validates_presence_of :ref
					#validates_presence_of :subject_id, :subject_type

					# *********************************************************
					# Title
					# *********************************************************

					before_save :update_title

				end

				module ClassMethods

					# *********************************************************
					# Definition of available selectors
					# *********************************************************

					#
					# Define new selector with select, search and title functions
					#
					def define_selector(ref, callbacks)
						raise "Please define select callback." if !callbacks[:select].is_a?(Proc)
						raise "Please define search callback." if !callbacks[:search].is_a?(Proc)
						raise "Please define title callback." if !callbacks[:title].is_a?(Proc)
						self.available_selectors[ref.to_sym] = callbacks
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
							self.available_selectors.each do |selector_ref, selector_def|
								selector_def[:search].call(query.to_s).each do |found_params|
									result << {
										value: encode_value(selector_ref, found_params),
										title: selector_def[:title].call(found_params)
									}
								end
							end
						end
						return result
					end

					# *********************************************************
					# Title
					# *********************************************************

					def title(value)
						ref, params = decode_value(value)
						selector_def = available_selectors[ref.to_sym]
						if selector_def && selector_def[:title]
							return selector_def[:title].call(params)
						else
							raise "Unknown selector."
						end
					end

					# *********************************************************
					# Value
					# *********************************************************

					def decode_value(value)
						splitted = value.split("/") # Parse value to ref and params
						ref = splitted.shift
						params = (splitted.empty? ? "null" : splitted.join("/"))
						params = (params == "null" ? nil : JSON.parse(params).symbolize_keys)
						return [ref, params]
					end

					def encode_value(ref, params)
						"#{ref}/#{params.to_json}"
					end

					# *********************************************************
					# People
					# *********************************************************

					def people(ref, params)
						selector_def = self.available_selectors[ref.to_sym]
						if selector_def && selector_def[:select]
							return selector_def[:select].call(params)
						else
							raise "Unknown selector."
						end
					end

				end

				# *************************************************************
				# Value
				# *************************************************************

				def value
					self.class.encode_value(self.ref, self.params)
				end

				def value=(value)
					self.ref, self.params = self.class.decode_value(value)
				end

				# *************************************************************
				# Params
				# *************************************************************

				def params
					return (read_attribute(:params) == "null" ? nil : JSON.parse(read_attribute(:params)).symbolize_keys)
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
						@people = self.class.people(self.ref, self.params)
					end
					return @people
				end

			protected

				def update_title
					self.title = self.class.title(self.value)
				end

			end
		end
	end
end