# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * User passwords
# *
# * Author: Matěj Outlý
# * Date  : 18. 6. 2015
# *
# *****************************************************************************

module RicUser
	module Concerns
		module Controllers
			module Admin
				module UserPasswordsController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do
					
						#
						# Set user before some actions
						#
						before_action :set_user, only: [:edit, :update, :regenerate]

					end

					#
					# Edit action
					#
					def edit
					end

					#
					# Update action
					#
					def update
						if @user.update_password(user_params[:password], user_params[:password_confirmation])
							redirect_to user_path(@user), notice: I18n.t("activerecord.notices.models.#{RicUser.user_model.model_name.i18n_key}.update")
						else
							render "edit"
						end
					end

					#
					# Regenerate action
					#
					def regenerate
						if @user.regenerate_password
							redirect_to user_path(@user), notice: I18n.t("activerecord.notices.models.#{RicUser.user_model.model_name.i18n_key}.update")
						else
							redirect_to user_path(@user), alert: I18n.t("activerecord.errors.models.#{RicUser.user_model.model_name.i18n_key}.regenerate_password")
						end
					end

				protected

					def set_user
						@user = RicUser.user_model.find_by_id(params[:id])
						if @user.nil?
							redirect_to users_path, alert: I18n.t("activerecord.errors.models.#{RicUser.user_model.model_name.i18n_key}.not_found")
						end
					end

					# 
					# Never trust parameters from the scary internet, only allow the white list through.
					#
					def user_params
						params.require(:user).permit(:password, :password_confirmation)
					end

				end
			end
		end
	end
end
