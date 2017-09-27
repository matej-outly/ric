# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * User assignment
# *
# * Author: Matěj Outlý
# * Date  : 31. 7. 2017
# *
# *****************************************************************************

module RicOrganization
	module Concerns
		module Models
			module UserAssignment extend ActiveSupport::Concern

				included do
					
					# *********************************************************
					# Structure
					# *********************************************************

					belongs_to :organization, class_name: RicOrganization.organization_model.to_s
					belongs_to :user, class_name: RicOrganization.user_model.to_s
					belongs_to :organization_assignment, class_name: RicOrganization.organization_assignment_model.to_s

					# *********************************************************
					# Validators
					# *********************************************************

					validates_presence_of :organization_id, :user_id

					# *************************************************************
					# User wrapper
					# *************************************************************

					after_find :load_user_attributes
					before_validation :ensure_user
					after_save :save_user_attributes
					after_destroy :cleanup_user

					RicOrganization.user_model.permitted_columns.each do |user_column|
						attr_accessor user_column
					end

				end

				module ClassMethods

					# *********************************************************
					# Columns
					# *********************************************************

					def permitted_columns
						return [
							:organization_assignment_id
							# ... define custom columns ...
						].concat(RicOrganization.user_model.permitted_columns)
					end

				end

				#
				# Person must be defined to be compatible with RicUser
				#
				def person
					self.organization
				end

			protected

				# *************************************************************
				# User wrapper
				# *************************************************************

				def ensure_user
					if self.user.nil? && !self.email.blank?
							
						# Find or create user object
						user = RicOrganization.user_model.find_by(email: self.email)
						if user.nil?
							user = RicOrganization.user_model.new(email: self.email)
							user.regenerate_password(notification: false)
							user.save
						end

						# Associate with user assignment
						self.user_id = user.id

					end
				end

				def cleanup_user
					if self.user && (self.user.user_assignment_ids - [self.id]).length == 0
						self.user.destroy
					end
				end

				def load_user_attributes
					if self.user
						RicOrganization.user_model.permitted_columns.each do |user_column|
							self.send("#{user_column}=", self.user.send(user_column))
						end
					end
				end

				def save_user_attributes
					if self.user
						RicOrganization.user_model.permitted_columns.each do |user_column|
							self.user.send("#{user_column}=", self.send(user_column))
						end
						self.user.save
					end
				end

			end
		end
	end
end