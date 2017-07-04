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

					included do
					
						before_action :set_user, only: [:show]

					end

					def index
						@users = RicUser.user_model.all.order(email: :asc).page(params[:page]).per(50)
					end

					def search
						@users = RicUser.user_model.search(params[:q]).order(name_lastname: :asc, name_firstname: :asc, email: :asc)
						respond_to do |format|
							format.html { render "index" }
							format.json { render json: @users.to_json }
						end
					end

					def show
						respond_to do |format|
							format.html { render "show" }
							format.json { render json: @user }
						end
					end

				protected

					# *********************************************************
					# Model setters
					# *********************************************************
					
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
