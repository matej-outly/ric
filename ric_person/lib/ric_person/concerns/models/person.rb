# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Person
# *
# * Author: Matěj Outlý
# * Date  : 23. 10. 2017
# *
# *****************************************************************************

module RicPerson
	module Concerns
		module Models
			module Person extend ActiveSupport::Concern

				included do
					
					# *********************************************************
					# Structure
					# *********************************************************

					belongs_to :user, class_name: RicPerson.user_model.to_s
					
					# *********************************************************
					# User wrapper
					# *********************************************************

					after_find :load_user_attributes
					before_save :ensure_user
					after_save :save_user_attributes
					after_destroy :cleanup_user

				end

				#
				# Magic method
				#
				def method_missing(name, *arguments)
					if self.user_attributes_ro.include?(name.to_sym)
						self.read_user_attribute(name.to_sym)
					elsif self.user_attributes_ro.map{ |ref| (ref.to_s + "=").to_sym }.include?(name.to_sym)
						if arguments.length != 1
							raise "Wrong number of arguments (given #{arguments.length}, expected 1)."
						end
						self.write_user_attribute(name.to_s[0..-2], arguments.first)
					else
						super
					end
				end
			
				# *************************************************************
				# User wrapper
				# *************************************************************

				def ensure_user

					# User not associated, but e-mail filled -> user must be found and associated
					if self.user.nil? && !self.email.blank?
						
						# Find or create user object
						target_user = RicPerson.user_model.find_by(email: self.email)
						if target_user.nil?
							target_user = RicPerson.user_model.new(email: self.email)
							target_user.regenerate_password(notification: false)
							raise "User not saved, errors: #{target_user.errors.inspect.to_s}" if !target_user.save
						end

						# Associate user object
						self.user_id = target_user.id

					end

					# User associated, but e-mail blanked -> user must not be associated
					if !self.user.nil? && self.email.blank?
						self.cleanup_user
					end

					# User associated, e-mail changed -> user must be reassociated
					if !self.user.nil? && !self.email.blank? && self.email != self.user.email

						if self.related_people.empty? # Current user has only one relation 

							target_user = RicPerson.user_model.find_by(email: self.email)
							if !target_user.nil? # Target e-mail exists in different user
								
								# Old user object destroyed
								self.user.destroy

								# Associate new user object
								self.user_id = target_user.id
								
							else # Completely new e-mail
								# Nothing to do, e-mail will be changed correctly in save_user_attributes
							end
						
						else # Current user has many relations

							# Unassociate current user object
							self.user_id = nil

							# Find or create user object
							target_user = RicPerson.user_model.find_by(email: self.email)
							if target_user.nil?
								target_user = RicPerson.user_model.new(email: self.email)
								target_user.regenerate_password(notification: false)
								raise "User not saved, errors: #{target_user.errors.inspect.to_s}" if !target_user.save
							end

							# Associate user object
							self.user_id = target_user.id

						end

					end

				end

				def cleanup_user
					return if self.user.nil?

					# Current user has only one relation 
					if self.related_people.empty? 
						self.user.destroy
					end
					
					self.user_id = nil
				end

				def related_people
					return if self.user.nil?

					result = []
					self.user.people.each do |person|
						if !(person.class.to_s == self.class.to_s && person.id == self.id)
							result << person
						end
					end
					return result
				end

			protected

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
						self.user_attributes_ro.each do |name|
							self.send("#{name}=", self.user.send(name)) if self.user.respond_to?(name)
						end
					end
				end

				def save_user_attributes
					if self.user
						self.user_attributes_rw.each do |name|
							self.user.send("#{name}=", self.send(name)) if self.user.respond_to?("#{name}=")
						end
						self.user.save
					end
				end

				def user_attributes_ro
					if @user_attributes_ro.nil?
						@user_attributes_ro = [:sign_in_count, :current_sign_in_at, :locked?]
						self.user_attributes_rw.each do |user_attribute|
							@user_attributes_ro << user_attribute
						end
					end
					return @user_attributes_ro
				end

				def user_attributes_rw
					if @user_attributes_rw.nil?
						@user_attributes_rw = []
						RicPerson.user_model.permitted_columns.each do |user_column|
							if user_column.is_a?(Symbol)
								@user_attributes_rw << user_column
							elsif user_column.is_a?(Hash)
								@user_attributes_rw << user_column.keys.first.to_sym
							end
						end
					end
					return @user_attributes_rw
				end

			end
		end
	end
end