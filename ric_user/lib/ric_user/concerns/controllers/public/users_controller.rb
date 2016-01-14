# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Users
# *
# * Author: Matěj Outlý
# * Date  : 9. 6. 2015
# *
# *****************************************************************************

module RicUser
	module Concerns
		module Controllers
			module Public
				module UsersController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do
					
						#
						# Set user before some actions
						#
						before_action :set_user, only: [:show]

					end

					#
					# Index action
					#
					def index
						@users = RicUser.user_model.search(params[:q]).order(email: :asc)
						respond_to do |format|
							format.html { render "index" }
							format.json { render json: @users.to_json }
						end
					end

					#
					# Show action
					#
					def show
						respond_to do |format|
							format.html { render "show" }
							format.json { render json: @user }
						end
					end

				protected

					def set_user
						@user = RicUser.user_model.find_by_id(params[:id])
						if @user.nil?
							redirect_to users_path, error: I18n.t("activerecord.errors.models.#{RicUser.user_model.model_name.i18n_key}.not_found")
						end
					end

				end
			end
		end
	end
end
