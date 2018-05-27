# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Numbered
# *
# * Author: Matěj Outlý
# * Date  : 3. 11. 2017
# *
# *****************************************************************************

module RicNumbering
	module Concerns
		module Models
			module Numbered extend ActiveSupport::Concern

				included do 

					# *********************************************************
					# Structure
					# *********************************************************

					has_many :sequences, class_name: RicNumbering.sequence_model.to_s, as: :scope

					# *********************************************************
					# Obtain number callback
					# *********************************************************

					# Object obtains solid number
					#before_validation :obtain_number
					before_save :obtain_number

				end

				#
				# Optional sequence owner
				# 
				def sequence_owner
					nil
				end

				#
				# Ref string for sequence indentification, must be set in concern user
				#
				# Return:
				# - nil if you don't want to generate number
				# - ref string if you do want to generate number
				#
				def sequence_ref
					raise "Please define numbering ref."
				end

				def _sequence_ref
					@sequence_ref ||= self.sequence_ref
				end

				#
				# Optional sequence share can be defined in concern user
				#
				def sequence_share
					nil
				end

				def _sequence_share
					@sequence_share ||= self.sequence_share
				end

				#
				# Optional sequence scope can be defined in concern user. it can be either model or simple string
				#
				def sequence_scope
					nil
				end

				#
				# Optional selector which identifies collection of numbered objects. With this, sequence can skip 
				# existing numbers to avoid duplicates.
				#
				def sequence_selector
					nil
				end

				#
				# Optional setting to only block obtained number. User must charge or uncharge obtained number
				# manually with sample.obtain_sequence.charge(sample.number) or sample.obtain_sequence.uncharge(sample.number)
				#
				def sequence_block
					nil
				end

				def obtain_sequence
					
					# Get sequence generator
					if self.sequence_owner && self.sequence_owner.respond_to?(:sequences)
						sequences = self.sequence_owner.sequences
					else
						sequences = RicNumbering.sequence_model
					end

					# Find correct sequence
					if self.sequence_scope.nil?
						sequence = sequences.find_or_create_by(ref: self._sequence_ref)
					else
						if self.sequence_scope.is_a?(ActiveRecord::Base)
							sequence = sequences.find_or_create_by(ref: self._sequence_ref, scope: self.sequence_scope)
						else
							scope_string = self.sequence_scope.to_s
							sequence = sequences.find_or_create_by(ref: self._sequence_ref, scope_string: scope_string)
						end
					end

					return sequence
				end

				def obtain_number
					ActiveRecord::Base.transaction do
						if self.number.nil? 
							if self._sequence_share

								# Share number
								self.number = self._sequence_share.number

							elsif self._sequence_ref

								# Get sequence
								sequence = self.obtain_sequence
								
								# Increase sequence number and save it to this object
								self.number = sequence.increase(
									selector: self.sequence_selector,
									block: self.sequence_block
								)

							end
						end
					end
				end

				def obtain_number!
					ActiveRecord::Base.transaction do
						self.obtain_number
						self.save
					end
				end

				#
				# Get number formatted into a fancy string according to configuration
				#
				def number_formatted
					if @number_formatted.nil? && !self.number.nil?
						if RicNumbering.sequence_formats && RicNumbering.sequence_formats[self.sequence_ref.to_sym]
							format_string = RicNumbering.sequence_formats[self.sequence_ref.to_sym]

							# Interpret
							scope = self.sequence_scope
							eval("format_string = \"#{format_string}\"")

							# Format
							@number_formatted = sprintf(format_string, self.number)
						else
							@number_formatted = self.number.to_s
						end
					end
					return @number_formatted
				end
		
			end
		end
	end
end