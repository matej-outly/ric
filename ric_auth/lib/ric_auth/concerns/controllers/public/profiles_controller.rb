# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Accounts
# *
# * Author: Matěj Outlý
# * Date  : 12. 11. 2015
# *
# *****************************************************************************

module RicAuth
	module Concerns
		module Controllers
			module Public
				module AccountsController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do
						
						before_action :authenticate_user!
						before_action :set_user

					end

					def edit
					end

					def update
						if @user.update(user_params)
							redirect_to ric_auth_public.edit_profile_path, notice: I18n.t("activerecord.notices.models.#{RicAuth.user_model.model_name.i18n_key}.update")
						else
							render "edit"
						end
					end

				protected

					def set_user
						@user = current_user
						if @user.nil?
							redirect_to main_app.root_path, alert: I18n.t("activerecord.errors.models.#{RicAuth.user_model.model_name.i18n_key}.not_found")
						end
					end

					# 
					# Never trust parameters from the scary internet, only allow the white list through.
					#
					def user_params
						params.require(:user).permit(
							:email, 
							{ :name => [:title, :firstname, :lastname] }
						)
					end
					
				end
			end
		end
	end
end