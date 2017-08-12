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
			module UsersController extend ActiveSupport::Concern

				included do
					
					before_action :save_referrer, only: [:new, :edit]
					before_action :set_user, only: [:show, :edit, :update, :lock, :unlock, :confirm, :destroy]

				end

				def index
					@filter_user = RicUser.user_model.new(load_params_from_session)
					@users = RicUser.user_model.filter(load_params_from_session).sorting(params[:sort], "email").page(params[:page]).per(50)
				end

				def filter
					save_params_to_session(filter_params)
					redirect_to users_path
				end

				def search
					@users = RicUser.user_model.search(params[:q]).order(name_lastname: :asc, name_firstname: :asc, email: :asc)
					respond_to do |format|
						format.html { render "index" }
						format.json { render json: @users.to_json }
					end
				end

				def show
				end

				def new
					@user = RicUser.user_model.new
				end

				def edit
				end

				def create
					@user = RicUser.user_model.new(user_params)
					@user.regenerate_password(notification: false)
					if @user.save
						redirect_to load_referrer, notice: I18n.t("activerecord.notices.models.#{RicUser.user_model.model_name.i18n_key}.create")
					else
						render "new"
					end
				end

				def update
					if @user.update(user_params)
						redirect_to load_referrer, notice: I18n.t("activerecord.notices.models.#{RicUser.user_model.model_name.i18n_key}.update")
					else
						render "edit"
					end
				end

				def lock
					if !@user.locked?
						@user.lock
						#sign_out(@user) Signs out current user also
						redirect_to request.referrer, notice: I18n.t("activerecord.notices.models.#{RicUser.user_model.model_name.i18n_key}.lock")
					else
						redirect_to request.referrer, alert: I18n.t("activerecord.errors.models.#{RicUser.user_model.model_name.i18n_key}.lock")
					end
				end

				def unlock
					if @user.locked?
						@user.unlock
						redirect_to request.referrer, notice: I18n.t("activerecord.notices.models.#{RicUser.user_model.model_name.i18n_key}.unlock")
					else
						redirect_to request.referrer, alert: I18n.t("activerecord.errors.models.#{RicUser.user_model.model_name.i18n_key}.unlock")
					end
				end

				def confirm
					if !@user.confirmed?
						@user.confirm
						redirect_to request.referrer, notice: I18n.t("activerecord.notices.models.#{RicUser.user_model.model_name.i18n_key}.confirm")
					else
						redirect_to request.referrer, alert: I18n.t("activerecord.errors.models.#{RicUser.user_model.model_name.i18n_key}.confirm")
					end
				end

				def destroy
					@user.destroy
					redirect_to users_path, notice: I18n.t("activerecord.notices.models.#{RicUser.user_model.model_name.i18n_key}.destroy")
				end

			protected

				# *************************************************************
				# Model setters
				# *************************************************************

				def set_user
					@user = RicUser.user_model.find_by_id(params[:id])
					if @user.nil?
						redirect_to users_path, error: I18n.t("activerecord.errors.models.#{RicUser.user_model.model_name.i18n_key}.not_found")
					end
				end

				# *************************************************************
				# Param filters
				# *************************************************************

				def user_params
					params.require(:user).permit(RicUser.user_model.permitted_columns)
				end

				def filter_params
					params.require(:user).permit(RicUser.user_model.filter_columns)
				end

			end
		end
	end
end
