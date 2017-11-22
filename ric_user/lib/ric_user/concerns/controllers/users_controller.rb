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
					
					before_action :set_user, only: [:show, :update, :lock, :unlock, :confirm, :destroy]

				end

				# *************************************************************
				# Actions
				# *************************************************************

				def index
					@filter_user = RicUser.user_model.new(load_params_from_session)
					@users = RicUser.user_model.filter(load_params_from_session).sorting(params[:sort], "email").page(params[:page]).per(50)
				end

				def filter
					save_params_to_session(filter_params)
					redirect_to users_path
				end

				def search
					@users = RicUser.user_model.search(params[:q]).order(
						name_lastname: :asc, 
						name_firstname: :asc, 
						email: :asc
					)
					respond_to do |format|
						format.html { render "index" }
						format.json { render json: @users.to_json }
					end
				end

				def show
				end

				def create
					@user = RicUser.user_model.new(user_params)
					@user.regenerate_password(notification: false)
					if @user.save
						respond_to do |format|
							format.html { redirect_to request.referrer, notice: RicUser.user_model.human_notice_message(:create) }
							format.json { render json: @user.id }
						end
					else
						respond_to do |format|
							format.html { redirect_to request.referrer, alert: RicUser.user_model.human_error_message(:create) }
							format.json { render json: @user.errors }
						end
					end
				end

				def update
					if @user.update(user_params)
						respond_to do |format|
							format.html { redirect_to request.referrer, notice: RicUser.user_model.human_notice_message(:update) }
							format.json { render json: @user.id }
						end
					else
						respond_to do |format|
							format.html { redirect_to request.referrer, alert: RicUser.user_model.human_error_message(:update) }
							format.json { render json: @user.errors }
						end
					end
				end

				def lock
					if !@user.locked? && (current_user.nil? || @user.id != current_user.id)
						@user.lock
						#sign_out(@user) Signs out current user also
						respond_to do |format|
							format.html { redirect_to request.referrer, notice: RicUser.user_model.human_notice_message(:lock) }
							format.json { render json: @user.id }
						end
					else
						respond_to do |format|
							format.html { redirect_to request.referrer, alert: RicUser.user_model.human_error_message(:lock) }
							format.json { render json: false }
						end
					end
				end

				def unlock
					if @user.locked? && (current_user.nil? || @user.id != current_user.id)
						@user.unlock
						respond_to do |format|
							format.html { redirect_to request.referrer, notice: RicUser.user_model.human_notice_message(:unlock) }
							format.json { render json: @user.id }
						end
					else
						respond_to do |format|
							format.html { redirect_to request.referrer, alert: RicUser.user_model.human_error_message(:unlock) }
							format.json { render json: false }
						end
					end
				end

				def confirm
					if !@user.confirmed?
						@user.confirm
						respond_to do |format|
							format.html { redirect_to request.referrer, notice: RicUser.user_model.human_notice_message(:confirm) }
							format.json { render json: @user.id }
						end
					else
						respond_to do |format|
							format.html { redirect_to request.referrer, alert: RicUser.user_model.human_error_message(:confirm) }
							format.json { render json: false }
						end
					end
				end

				def destroy
					@user.destroy
					respond_to do |format|
						format.html { redirect_to request.referrer, notice: RicUser.user_model.human_notice_message(:destroy) }
						format.json { render json: @user.id }
					end
				end

			protected

				# *************************************************************
				# Model setters
				# *************************************************************

				def set_user
					@user = RicUser.user_model.find_by_id(params[:id])
					not_found if @user.nil?
				end

				# *************************************************************
				# Param filters
				# *************************************************************

				def user_params
					return params.require(:user).permit(RicUser.user_model.permitted_columns)
				end

				def filter_params
					return params.require(:user).permit(RicUser.user_model.filter_columns)
				end

			end
		end
	end
end
