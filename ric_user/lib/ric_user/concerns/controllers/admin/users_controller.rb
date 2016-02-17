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
			module Admin
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
						before_action :set_user, only: [:show, :edit, :update, :lock, :unlock, :confirm, :destroy]

					end

					#
					# Index action
					#
					def index
						@users = RicUser.user_model.all.sorting(params[:sort], "email").page(params[:page]).per(50)
					end

					#
					# Search action
					#
					def search
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
					end

					#
					# New action
					#
					def new
						@user = RicUser.user_model.new
					end

					#
					# Edit action
					#
					def edit
					end

					#
					# Create action
					#
					def create
						@user = RicUser.user_model.new(user_params)
						@user.regenerate_password(disable_email: true)
						if @user.save
							redirect_to user_path(@user), notice: I18n.t("activerecord.notices.models.#{RicUser.user_model.model_name.i18n_key}.create")
						else
							render "new"
						end
					end

					#
					# Update action
					#
					def update
						if @user.update(user_params)
							redirect_to user_path(@user), notice: I18n.t("activerecord.notices.models.#{RicUser.user_model.model_name.i18n_key}.update")
						else
							render "edit"
						end
					end

					#
					# Lock action
					#
					def lock
						if !@user.locked?
							@user.lock
							#sign_out(@user) Signs out current user also
							redirect_to user_path(@user), notice: I18n.t("activerecord.notices.models.#{RicUser.user_model.model_name.i18n_key}.lock")
						else
							redirect_to user_path(@user), alert: I18n.t("activerecord.errors.models.#{RicUser.user_model.model_name.i18n_key}.lock")
						end
					end

					#
					# Unlock action
					#
					def unlock
						if @user.locked?
							@user.unlock
							redirect_to user_path(@user), notice: I18n.t("activerecord.notices.models.#{RicUser.user_model.model_name.i18n_key}.unlock")
						else
							redirect_to user_path(@user), alert: I18n.t("activerecord.errors.models.#{RicUser.user_model.model_name.i18n_key}.unlock")
						end
					end

					#
					# Confirm action
					#
					def confirm
						if !@user.confirmed?
							@user.confirm
							redirect_to user_path(@user), notice: I18n.t("activerecord.notices.models.#{RicUser.user_model.model_name.i18n_key}.confirm")
						else
							redirect_to user_path(@user), alert: I18n.t("activerecord.errors.models.#{RicUser.user_model.model_name.i18n_key}.confirm")
						end
					end

					#
					# Destroy action
					#
					def destroy
						@user.destroy
						redirect_to users_path, notice: I18n.t("activerecord.notices.models.#{RicUser.user_model.model_name.i18n_key}.destroy")
					end

				protected

					def set_user
						@user = RicUser.user_model.find_by_id(params[:id])
						if @user.nil?
							redirect_to users_path, error: I18n.t("activerecord.errors.models.#{RicUser.user_model.model_name.i18n_key}.not_found")
						end
					end

					# 
					# Never trust parameters from the scary internet, only allow the white list through.
					#
					def user_params
						params.require(:user).permit(:email, :role, :name => [:title, :firstname, :lastname])
					end

				end
			end
		end
	end
end
