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
					# Validators
					# *********************************************************

					validates_presence_of :user_id
					#validates_presence_of :email Not working since email is virtual attribute

					# *************************************************************
					# User wrapper
					# *************************************************************

					after_find :load_user_attributes
					before_validation :ensure_user
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
					if self.user.nil? && !self.email.blank?
						
						# Find or create user object
						user = RicPerson.user_model.find_by(email: self.email)
						if user.nil?
							user = RicPerson.user_model.new(email: self.email)
							user.regenerate_password(notification: false)
							if !user.save
								raise "User not saved, errors: #{user.errors.inspect.to_s}"
							end
						end

						# Associate with user assignment
						self.user_id = user.id

					end
				end

				def cleanup_user
					# TODO check all person types
					#if self.user && (self.user.user_assignment_ids - [self.id]).length == 0
					#	self.user.destroy
					#end
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