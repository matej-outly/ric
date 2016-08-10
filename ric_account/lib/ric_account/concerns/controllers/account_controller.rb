# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Account
# *
# * Author: Matěj Outlý
# * Date  : 5. 5. 2015
# *
# *****************************************************************************

module RicAccount
	module Concerns
		module Controllers
			module AccountController extend ActiveSupport::Concern

				#
				# 'included do' causes the included code to be evaluated in the
				# context where it is included, rather than being executed in 
				# the module's context.
				#
				included do

					#
					# Set banner before some actions
					#
					before_action :set_user
	
				end

				def user
				end

				def user_update
					if @user.update(user_params)
						redirect_to account_user_path, notice: I18n.t("activerecord.notices.models.ric_account/account.user_update")
					else
						render "user"
					end
				end

				def password
				end

				def password_update
					if @user.update_with_password(password_params)
						sign_in @user, :bypass => true
						redirect_to account_user_path, notice: I18n.t("activerecord.notices.models.ric_account/account.password_update")
					else
						render "password"
					end
				end

			protected

				def set_user
					@user = current_user
					if @user.nil?
						redirect_to main_app.root_path, alert: I18n.t("activerecord.errors.models.ric_user/user.not_found")
					end
				end

				# 
				# Never trust parameters from the scary internet, only allow the white list through.
				#
				def user_params
					params.require(:user).permit(
						:email, 
						:name => [:title, :firstname, :lastname]
					)
				end

				# 
				# Never trust parameters from the scary internet, only allow the white list through.
				#
				def password_params
					params.require(:user).permit(
						:current_password, 
						:password, 
						:password_confirmation
					)
				end

			end
		end
	end
end