# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Validity
# *
# * Author: Matěj Outlý
# * Date  : 19. 2. 2017
# *
# *****************************************************************************

module RicCalendar
	module Concerns
		module Models
			module Validity extend ActiveSupport::Concern

				included do

					# *********************************************************
					# Validators
					# *********************************************************

					#validates :valid_from, :valid_to, presence: true
					validate :validate_valid_from_to_consistency
					
					# *********************************************************
					# Callbacks
					# *********************************************************

					before_validation :set_valid_from_to_before_validation
					
				end

				module ClassMethods
					
					# *********************************************************
					# Columns
					# *********************************************************

					#
					# Get all columns permitted for editation
					#
					def permitted_columns_for_validity
						[
							:valid_from,
							:valid_to
						]
					end

					# *********************************************************
					# Scopes
					# *********************************************************

					#
					# Scope for yet invalid records
					#
					def yet_invalid(date)
						where("valid_from > :date", date: date)
					end

					#
					# Scope for already invalid records
					#
					def already_invalid(date)
						where("valid_to <= :date", date: date)
					end

					#
					# Scope for valid records
					#
					def valid(date_from, date_to = nil)
						date_to = date_from + 1.day if date_to.nil?
						where("(valid_from < :date_to OR valid_from IS NULL) AND (:date_from < valid_to OR valid_to IS NULL)", date_from: date_from, date_to: date_to)
					end

				end

				# *************************************************************
				# Actions
				# *************************************************************

				#
				# Make record already invalid (should be used instead of destroy)
				#
				def invalidate(date)
					self.valid_to = date
					self.save
				end

				# *************************************************************
				# Predicates
				# *************************************************************

				#
				# Is record yet invalid?
				#
				def is_yet_invalid?(date)
					return !self.valid_from.nil? && self.valid_from > date
				end

				#
				# Is record already invalid?
				#
				def is_already_invalid?(date)
					return !self.valid_to.nil? && self.valid_to <= date
				end

				#
				# Is record valid?
				#
				def is_valid?(date_from, date_to = nil)
					date_to = date_from + 1.day if date_to.nil?
					return (self.valid_from.nil? || self.valid_from < date_to) && (self.valid_to.nil? || date_from < self.valid_to)
				end

			protected

				#
				# "From" must be before "to" (causality)
				#
				def validate_valid_from_to_consistency
					if self.valid_from.nil? || self.valid_to.nil?
						return
					end

					# Causality on valid_from & valid_to
					if self.valid_from > self.valid_to
						errors.add(:valid_to, I18n.t("activerecord.errors.models.#{self.class.model_name.i18n_key}.attributes.valid_to.before_from"))
					end
				end

				#
				# Set valid from / valid to correctly
				#
				def set_valid_from_to_before_validation
					if self.respond_to?(:date_from) && self.respond_to?(:date_to)
						if self.respond_to?(:is_recurring?) && !is_recurring?
							self.valid_from = self.date_from
							self.valid_to = self.date_to
						else
							# In this case valid_from and valid_to id set by user and date_from is changed respectively before validatation
						end
					end
				end

			end

		end
	end
end