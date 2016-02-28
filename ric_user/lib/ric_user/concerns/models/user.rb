# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * User
# *
# * Author: Matěj Outlý
# * Date  : 9. 6. 2015
# *
# *****************************************************************************

module RicUser
	module Concerns
		module Models
			module User extend ActiveSupport::Concern

				#
				# 'included do' causes the included code to be evaluated in the
				# context where it is included, rather than being executed in 
				# the module's context.
				#
				included do
					
					# *********************************************************
					# Devise definition
					# *********************************************************

					#
					# Include default devise modules. Others available are:
					# :confirmable, :lockable, :timeoutable and :omniauthable
					#
					devise *(config(:devise).map { |feature| feature.to_sym })

					# *********************************************************
					# Structure
					# *********************************************************

					#
					# One-to-many relation with persons
					#
					belongs_to :person, polymorphic: true

					# *********************************************************
					# Role
					# *********************************************************

					enum_column :role, config(:roles), default: config(:default_role)

					# *********************************************************
					# Name
					# *********************************************************

					name_column :name

					#
					# Add formatted name to JSON output
					#
					add_methods_to_json :name_formatted

					# *********************************************************
					# Validators
					# *********************************************************

					#
					# E-mail must be set
					#
					validates_presence_of :email

					# *********************************************************
					# Locking & confirmation
					# *********************************************************
					
					define_method :active_for_authentication? do
						return false if self.class.confirmable? && !confirmed?
						return false if locked?
						return true
					end

					define_method :inactive_message do
						return :unconfirmed if self.class.confirmable? && !confirmed?
						return :inactive # if locked?
					end

				end

				module ClassMethods

					# *********************************************************
					# Scopes
					# *********************************************************

					def search(query)
						if query.blank?
							all
						else
							where("(lower(unaccent(email)) LIKE ('%' || lower(unaccent(trim(:query))) || '%')) OR (lower(unaccent(name_lastname)) LIKE ('%' || lower(unaccent(trim(:query))) || '%')) OR (lower(unaccent(name_firstname)) LIKE ('%' || lower(unaccent(trim(:query))) || '%'))", query: query)
						end
					end

					# *********************************************************
					# Features
					# *********************************************************

					def database_authenticatable?
						config(:devise).include?("database_authenticatable")
					end

					def recoverable?
						config(:devise).include?("recoverable")
					end

					def rememberable?
						config(:devise).include?("rememberable")
					end

					def trackable?
						config(:devise).include?("trackable")
					end

					def validatable?
						config(:devise).include?("validatable")
					end

					def registerable?
						config(:devise).include?("registerable")
					end

					def confirmable?
						config(:devise).include?("confirmable")
					end

					def lockable?
						config(:devise).include?("lockable")
					end

					def timeoutable?
						config(:devise).include?("timeoutable")
					end

					def omniauthable?
						config(:devise).include?("omniauthable")
					end

				end

				# *************************************************************
				# Password
				# *************************************************************

				def regenerate_password(options = {})
					new_password = RugSupport::Util::String.random(4)
					
					# Save
					self.password = new_password
					result = self.save

					# Deliver email
					if result && options[:disable_email] != true
						begin 
							RicUser::UserMailer.new_password(self, new_password).deliver_now
						rescue Net::SMTPFatalError
						end
					end

					return result
				end

				def update_password(new_password, password_confirmation, options = {})
					
					# Check blank
					if new_password.blank?
						errors.add(:password, I18n.t("activerecord.errors.models.ric_user/user.attributes.password.blank"))
						return false
					end

					# Check confirmation
					if new_password != password_confirmation
						errors.add(:password_confirmation, I18n.t("activerecord.errors.models.ric_user/user.attributes.password_confirmation.confirmation"))
						return false
					end

					# Save
					self.password = new_password
					result = self.save

					# Deliver email
					if result && options[:disable_email] != true
						begin 
							RicUser::UserMailer.new_password(self, new_password).deliver_now
						rescue Net::SMTPFatalError
						end
					end

					return result
				end

				# *************************************************************
				# Locking
				# *************************************************************

				def locked?
					return !self.locked_at.nil?	
				end

				def lock
					self.locked_at = Time.current
					self.save
				end

				def unlock
					self.locked_at = nil
					self.save
				end

			end
		end
	end
end