# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Sequence
# *
# * Author: Matěj Outlý
# * Date  : 3. 11. 2017
# *
# *****************************************************************************

module RicNumbering
	module Concerns
		module Models
			module Sequence extend ActiveSupport::Concern

				included do
					
					# *********************************************************
					# Structure
					# *********************************************************

					belongs_to :owner, polymorphic: true
					belongs_to :scope, polymorphic: true

					# *********************************************************
					# Validators
					# *********************************************************
					
					validates_presence_of :ref, :current

					# *********************************************************
					# Default value
					# *********************************************************

					before_validation do
						self.current = 0 if self.current.nil?
					end

					# *********************************************************
					# Ref
					# *********************************************************

					if RicNumbering.sequence_refs
						enum_column :ref, RicNumbering.sequence_refs
					end

					# *********************************************************
					# Blocked numbers
					# *********************************************************

					array_column :blocked_numbers

				end

				#
				# Increase current number return it as result. Can return nil if 
				# free number not found.
				#
				def increase(options = {})
					result = nil
					working_current = self.current

					# Increase
					checks = 0
					while checks < 1000 # Some check limit to fail correctly
						working_current += 1
						if self.blocked_numbers.nil? || !self.blocked_numbers.include?(working_current) # Not blocked
							if options[:selector].nil?
								result = working_current # No selector provided -> just increase without dulicity check
								break
							else
								if options[:selector].where(number: working_current).count == 0
									result = working_current
									break
								end
							end
						end
						checks += 1
					end
					
					# Save current or block it
					if options[:block] == true
						if result
							if self.blocked_numbers.nil?
								self.blocked_numbers = [result]
							else
								self.blocked_numbers = (self.blocked_numbers + [result]).uniq
							end
							self.save
						end
					else
						self.current = working_current # Increase even if no result found
						self.save
					end

					return result
				end

				def unblock(number)
					if !self.blocked_numbers.nil? && self.blocked_numbers.include?(number)
						working_blocked_numbers = self.blocked_numbers
						working_blocked_numbers.delete(number)
						if working_blocked_numbers.empty?
							self.blocked_numbers = nil
						else
							self.blocked_numbers = working_blocked_numbers
						end
						self.save
						return true
					else
						return false
					end
				end

				def charge(number)
					if !self.blocked_numbers.nil? && self.blocked_numbers.include?(number)
						working_blocked_numbers = self.blocked_numbers
						working_blocked_numbers.delete(number)
						if working_blocked_numbers.empty?
							self.blocked_numbers = nil
						else
							self.blocked_numbers = working_blocked_numbers
						end
						self.current = number # Also set current
						self.save
						return true
					else
						return false
					end
				end

				def uncharge(number)
					self.unblock(number)
				end
			
			end
		end
	end
end