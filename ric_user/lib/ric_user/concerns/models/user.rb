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
					# Enums
					# *********************************************************

					#
					# Role
					#
					enum_column :role, config(:roles), default: config(:default_role)

				end

				module ClassMethods

					# *********************************************************
					# Scopes
					# *********************************************************

					def search(query)
						if query.blank?
							all
						else
							#where("(lower(unaccent(name_lastname)) LIKE ('%' || lower(unaccent(trim(:query))) || '%')) OR (lower(unaccent(name_firstname)) LIKE ('%' || lower(unaccent(trim(:query))) || '%'))", query: query)
							where("(lower(unaccent(email)) LIKE ('%' || lower(unaccent(trim(:query))) || '%'))", query: query)
						end
					end

				end

				# *************************************************************
				# Interfaces
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

			end
		end
	end
end