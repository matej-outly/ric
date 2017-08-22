# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Roles
# *
# * Author: Matěj Outlý
# * Date  : 9. 6. 2015
# *
# *****************************************************************************

module RicUser
	module Concerns
		module Controllers
			module RolesController extend ActiveSupport::Concern
				
				included do
					before_action :set_role, only: [:update, :destroy]
				end
				
				# *************************************************************
				# Actions
				# *************************************************************

				def index
					@filter_role = RicUser.role_model.new(load_params_from_session)
					@roles = RicUser.role_model.filter(load_params_from_session).order(name: :asc).page(params[:page]).per(50)
				end

				def filter
					save_params_to_session(filter_params)
					redirect_to roles_path
				end

				def search
					@roles = RicUser.role_model.search(params[:q]).order(name: :asc)
					respond_to do |format|
						format.html { render "index" }
						format.json { render json: @roles.to_json }
					end
				end

				def create
					@role = RicUser.role_model.new(role_params)
					if @role.save
						respond_to do |format|
							format.html { redirect_to request.referrer, notice: RicUser.role_model.human_notice_message(:create) }
							format.json { render json: @role.id }
						end
					else
						respond_to do |format|
							format.html { redirect_to request.referrer, alert: RicUser.role_model.human_error_message(:create) }
							format.json { render json: @role.errors }
						end
					end
				end

				def update
					if @role.update(role_params)
						respond_to do |format|
							format.html { redirect_to request.referrer, notice: RicUser.role_model.human_notice_message(:update) }
							format.json { render json: @role.id }
						end
					else
						respond_to do |format|
							format.html { redirect_to request.referrer, alert: RicUser.role_model.human_error_message(:update) }
							format.json { render json: @role.errors }
						end
					end
				end

				def destroy
					@role.destroy
					respond_to do |format|
						format.html { redirect_to request.referrer, notice: RicUser.role_model.human_notice_message(:destroy) }
						format.json { render json: @role.id }
					end
				end

			protected

				# *************************************************************
				# Model setters
				# *************************************************************

				def set_role
					@role = RicUser.role_model.find_by_id(params[:id])
					not_found if @role.nil?
				end

				# *************************************************************
				# Param filters
				# *************************************************************

				def role_params
					return params.require(:role).permit(RicUser.role_model.permitted_columns)
				end

				def filter_params
					return params.require(:role).permit(RicUser.role_model.filter_columns)
				end

			end
		end
	end
end
