# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Reservation
# *
# * Author: Matěj Outlý
# * Date  : 7. 12. 2015
# *
# *****************************************************************************

module RicReservation
	module Concerns
		module Models
			module Reservation extend ActiveSupport::Concern

				#
				# 'included do' causes the included code to be evaluated in the
				# context where it is included, rather than being executed in 
				# the module's context.
				#
				included do
					
					# *********************************************************
					# Structure
					# *********************************************************

					#
					# One-to-many relation with owners
					#
					belongs_to :owner, class_name: RicReservation.owner_model.to_s

					#
					# One-to-many relation with subjects
					#
					belongs_to :subject, polymorphic: true

					# *********************************************************
					# Validators
					# *********************************************************

					#
					# Some columns must be present (always)
					#
					validates_presence_of :kind, :schedule_from, :schedule_to

					# *********************************************************
					# Kind
					# *********************************************************

					#
					# Kind
					#
					enum_column :kind, ["event", "resource"]

				end

				# *************************************************************
				# Kind
				# *************************************************************

				#
				# Is kind event?
				#
				def kind_event?
					self.kind == "event"
				end

				#
				# Is kind resource?
				#
				def kind_resource?
					self.kind == "resource"
				end

				# *************************************************************
				# Schedule time
				# *************************************************************

				#
				# Schedule time
				#
				def schedule_formatted_time
					return self.schedule_from.strftime("%k:%M") + " - " + self.schedule_to.strftime("%k:%M")
				end

				# *************************************************************
				# State
				# *************************************************************

				#
				# Get state according to current date and time
				#
				def state
					
					if @state.nil?
						now = Time.current
						
						# Break points
						if self.kind_event?
							deadline = self.schedule_from - self.event.time_window_deadline
							soon = deadline - self.event.time_window_soon
						else # if self.kind_resource?
							deadline = self.schedule_from - self.resource.time_window_deadline
							soon = deadline - self.resource.time_window_soon
						end

						# State recognititon
						if now < soon
							@state = :open
						elsif now < deadline
							@state = :soon
						elsif now < self.schedule_from
							@state = :deadline
						else
							@state = :closed
						end

					end
					return @state
				end
				
			protected

			end
		end
	end
end