# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Profiles
# *
# * Author: Matěj Outlý
# * Date  : 12. 11. 2015
# *
# *****************************************************************************

module RicAuthAdmin
	module Concerns
		module Controllers
			module ProfilesController extend ActiveSupport::Concern

				#
				# 'included do' causes the included code to be evaluated in the
				# context where it is included, rather than being executed in 
				# the module's context.
				#
				included do
					
					before_action :authenticate_user!
					before_action :set_user

				end

				def show
					render json: @user.to_json
				end

				def edit
				end

				def update
					if @user.update(user_params)
						respond_to do |format|
							format.html { redirect_to ric_auth_admin.edit_profile_path, notice: I18n.t("activerecord.notices.models.#{RicAuthAdmin.user_model.model_name.i18n_key}.update") }
							format.json { render json: @user.id }
						end
					else
						respond_to do |format|
							format.html { render "edit" }
							format.json { render json: @user.errors }
						end
					end
				end

			protected

				def set_user
					@user = current_user
					if @user.nil?
						redirect_to main_app.root_path, alert: I18n.t("activerecord.errors.models.#{RicAuthAdmin.user_model.model_name.i18n_key}.not_found")
					end
				end

				def user_params
					params.require(RicAuth.user_model.model_name.param_key).permit(RicAuthAdmin.user_model.profile_columns)
				end

			end
		end
	end
end