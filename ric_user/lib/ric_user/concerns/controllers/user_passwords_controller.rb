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
			module UserPasswordsController extend ActiveSupport::Concern

				included do
				
					before_action :set_user

				end

				# *************************************************************
				# Actions
				# *************************************************************

				def update
					if @user.update_password(user_params[:password], user_params[:password_confirmation])
						respond_to do |format|
							format.html { redirect_to request.referrer, notice: RicUser::User.human_notice_message(:update_password) }
							format.json { render json: @user.id }
						end
					else
						respond_to do |format|
							format.html { redirect_to request.referrer, alert: RicUser::User.human_error_message(:update_password) }
							format.json { render json: @user.errors }
						end
					end
				end

				def regenerate
					if @user.regenerate_password
						respond_to do |format|
							format.html { redirect_to request.referrer, notice: RicUser::User.human_notice_message(:regenerate_password) }
							format.json { render json: @user.id }
						end
					else
						respond_to do |format|
							format.html { redirect_to request.referrer, alert: RicUser::User.human_error_message(:regenerate_password) }
							format.json { render json: false }
						end
					end
				end

			protected

				# *************************************************************
				# Model setters
				# *************************************************************

				def set_user
					@user = RicUser.user_model.find_by_id(params[:user_id])
					not_found if @user.nil?
				end

				# *************************************************************
				# Param filters
				# *************************************************************

				def user_params
					params.require(:user).permit(:password, :password_confirmation)
				end

			end
		end
	end
end
