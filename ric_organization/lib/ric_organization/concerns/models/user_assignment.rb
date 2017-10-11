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
					belongs_to :organization_assignment, class_name: RicOrganization.organization_assignment_model.to_s if RicOrganization.enable_organization_assignments

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

				#
				# Magic method
				#
				def method_missing(name, *arguments)
					if self.user_attributes.include?(name.to_sym)
						self.read_user_attribute(name.to_sym)
					elsif self.user_attributes.map{ |ref| (ref.to_s + "=").to_sym }.include?(name.to_sym)
						if arguments.length != 1
							raise "Wrong number of arguments (given #{arguments.length}, expected 1)."
						end
						self.write_user_attribute(name.to_s[0..-2], arguments.first)
					else
						super
					end
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

				def read_user_attribute(name)
					@user_values = {} if @user_values.nil?
					return @user_values[name.to_sym]
				end

				def write_user_attribute(name, value)
					@user_values = {} if @user_values.nil?
					@user_values[name.to_sym] = value
					return value
				end

				def load_user_attributes
					if self.user
						self.user_attributes.each do |name|
							self.send("#{name}=", self.user.send(name)) if self.user.respond_to?(name)
						end
					end
				end

				def save_user_attributes
					if self.user
						self.user_attributes.each do |name|
							self.user.send("#{name}=", self.send(name)) if self.user.respond_to?("#{name}=")
						end
						self.user.save
					end
				end

				def user_attributes
					if @user_attributes.nil?
						@user_attributes = []
						RicOrganization.user_model.permitted_columns.each do |user_column|
							if user_column.is_a?(Symbol)
								@user_attributes << user_column
							elsif user_column.is_a?(Hash)
								@user_attributes << user_column.keys.first.to_sym
							end
						end
					end
					return @user_attributes
				end

			end
		end
	end
end