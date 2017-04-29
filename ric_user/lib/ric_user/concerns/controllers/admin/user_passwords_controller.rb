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

					included do
					
						before_action :set_user, only: [:edit, :update, :regenerate]

					end

					def edit
					end

					def update
						if @user.update_password(user_params[:password], user_params[:password_confirmation])
							redirect_to user_path(@user), notice: I18n.t("activerecord.notices.models.#{RicUser.user_model.model_name.i18n_key}.update_password")
						else
							render "edit"
						end
					end

					def regenerate
						if @user.regenerate_password
							redirect_to user_path(@user), notice: I18n.t("activerecord.notices.models.#{RicUser.user_model.model_name.i18n_key}.regenerate_password")
						else
							redirect_to user_path(@user), alert: I18n.t("activerecord.errors.models.#{RicUser.user_model.model_name.i18n_key}.regenerate_password")
						end
					end

				protected

					# *********************************************************
					# Model setters
					# *********************************************************

					def set_user
						@user = RicUser.user_model.find_by_id(params[:id])
						if @user.nil?
							redirect_to users_path, alert: I18n.t("activerecord.errors.models.#{RicUser.user_model.model_name.i18n_key}.not_found")
						end
					end

					# *********************************************************
					# Param filters
					# *********************************************************

					def user_params
						params.require(:user).permit(:password, :password_confirmation)
					end

				end
			end
		end
	end
end
