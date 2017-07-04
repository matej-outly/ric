# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Session
# *
# * Author: Matěj Outlý
# * Date  : 26. 11. 2015
# *
# *****************************************************************************

module RicUser
	module Concerns
		module Models
			module Session extend ActiveSupport::Concern

				included do

					#
					# Set primary key
					#
					self.primary_key = :id

				end

				module ClassMethods

					#
					# Get current session ID
					#
					def current_id(current_controller_session)
						if current_controller_session.id.nil?
							current_controller_session[:tmp] = "tmp"
							current_controller_session.delete(:tmp)
						end
						return current_controller_session.id
					end

					#
					# Get session object
					#
					def find(session_id)
						return RicUser.session_model.find_by_id(session_id)
					end

					#
					# Get session object
					#
					def find_or_create(session_id)
						begin
							return RicUser.session_model.find_or_create_by(id: session_id)
						rescue ActiveRecord::RecordNotUnique
							retry
						end
					end

					#
					# Cleanup old sessions
					#
					def cleanup
						now = Time.current
						RicUser.session_model.delete_all(["updated_at < ?", (now - self.cleanup_timeout)])
					end

					#
					# Get cleanup timeout
					#
					def cleanup_timeout
						return 1.day
					end

				end

			end
		end
	end
end