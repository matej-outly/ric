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
					before_validation :obtain_number

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

				#
				# Optional sequence share can be defined in concern user
				#
				def sequence_share
					nil
				end

				#
				# Optional sequence scope can be defined in concern user
				#
				def sequence_scope
					nil
				end

				def obtain_number
					ActiveRecord::Base.transaction do
						if self.number.nil? 
							share = self.sequence_share
							ref = self.sequence_ref
							
							if share

								# Share number
								self.number = share.number

							elsif ref

								# Get sequence generator
								if self.sequence_owner && self.sequence_owner.respond_to?(:sequences)
									sequences = self.sequence_owner.sequences
								else
									sequences = RicNumbering.sequence_model
								end

								# Find correct sequence
								if self.sequence_scope.nil?
									sequence = sequences.find_or_create_by(ref: ref)
								else
									sequence = sequences.find_or_create_by(ref: ref, scope: self.sequence_scope)
								end

								# Increase sequence number and save it to this object
								self.number = sequence.increase

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
							@number_formatted = sprintf(RicNumbering.sequence_formats[self.sequence_ref.to_sym], self.number)
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