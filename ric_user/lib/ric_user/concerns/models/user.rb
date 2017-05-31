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
					# Name
					# *********************************************************

					name_column :name
					add_methods_to_json :name_formatted

					# *********************************************************
					# Avatar
					# *********************************************************

					if config(:avatar_croppable) == true
						croppable_picture_column :avatar, styles: { thumb: config(:avatar_crop, :thumb), full: config(:avatar_crop, :full) }
					else
						has_attached_file :avatar, :styles => { thumb: config(:avatar_crop, :thumb), full: config(:avatar_crop, :full) }
						validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
					end
					add_methods_to_json :avatar_url

					# *********************************************************
					# Validators
					# *********************************************************

					validates_presence_of :email

				end

				module ClassMethods

					# *********************************************************
					# Columns
					# *********************************************************

					def permitted_columns
						[
							:email, 
							:role,
							:avatar,
							:avatar_crop_x, 
							:avatar_crop_y, 
							:avatar_crop_w, 
							:avatar_crop_h,
							:avatar_perform_cropping,
							{:name => [:title, :firstname, :lastname]}
						]
					end

					def profile_columns
						[
							:email, 
							:avatar,
							:avatar_crop_x, 
							:avatar_crop_y, 
							:avatar_crop_w, 
							:avatar_crop_h,
							:avatar_perform_cropping,
							{:name => [:title, :firstname, :lastname]}
						]
					end

					def filter_columns
						[
							:email, 
						]
					end

					# *********************************************************
					# Scopes
					# *********************************************************

					def search(query)
						if query.blank?
							all
						else
							where("
								(lower(unaccent(email)) LIKE ('%' || lower(unaccent(trim(:query))) || '%')) OR 
								(lower(unaccent(name_lastname)) LIKE ('%' || lower(unaccent(trim(:query))) || '%')) OR 
								(lower(unaccent(name_firstname)) LIKE ('%' || lower(unaccent(trim(:query))) || '%'))
							", query: query)
						end
					end

					def filter(params = {})
						
						# Preset
						result = all

						# E-mail
						if !params[:email].blank?
							result = result.where("lower(unaccent(email)) LIKE ('%' || lower(unaccent(trim(?))) || '%')", params[:email].to_s)
						end
					
						result
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

					# Notification
					if result
						if options[:notification] == false
							# No notification
						elsif options[:notification] == "email"
							begin 
								RicUser::UserMailer.new_password(self, new_password).deliver_now
							rescue Net::SMTPFatalError, Net::SMTPSyntaxError
							end
						else
							RicNotification.notify([:user_new_password, self, new_password], self) if !(defined?(RicNotification).nil?)
						end
					end

					# Set password as result if everything OK
					result = new_password if result

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

					# Notification
					if result
						if options[:notification] == false
							# No notification
						elsif options[:notification] == "email"
							begin 
								RicUser::UserMailer.new_password(self, new_password).deliver_now
							rescue Net::SMTPFatalError, Net::SMTPSyntaxError
							end
						else
							RicNotification.notify([:user_new_password, self, new_password], self) if !(defined?(RicNotification).nil?)
						end
					end

					# Set passowrd as result if everything OK
					result = new_password if result
					
					return result
				end

				# *************************************************************
				# Avatar
				# *************************************************************

				def avatar_url
					(self.avatar.present? ? self.avatar.url : nil)
				end

			end
		end
	end
end