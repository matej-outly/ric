# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Session
# *
# * Author: Matěj Outlý
# * Date  : 9. 6. 2015
# *
# *****************************************************************************

module RicUser
	module Concerns
		module Controllers
			module Public
				module SessionController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do
					
						#
						# Set user before some actions
						#
						before_action :set_session_soft, only: [:show]
						before_action :set_session_hard, only: [:edit, :update]

					end

					#
					# Show action
					#
					def show
						respond_to do |format|
							format.html { render "show" }
							format.json { render json: @session.to_json }
						end
					end

					#
					# Edit action
					#
					def edit
					end

					#
					# Update action
					#
					def update
						if @session.update(session_params)
							respond_to do |format|
								format.html { redirect_to session_updated_path, notice: I18n.t("activerecord.notices.models.#{RicUser.session_model.model_name.i18n_key}.update") }
								format.json { render json: @session.id }
							end
						else
							respond_to do |format|
								format.html { render "edit" }
								format.json { render json: @session.errors }
							end
						end
					end

				protected

					#
					# Set model
					#
					def set_session_soft
						@session = RicUser.session_model.find(RicUser.session_model.current_id(session))
					end

					#
					# Set model
					#
					def set_session_hard
						@session = RicUser.session_model.find_or_create(RicUser.session_model.current_id(session))
					end

					#
					# Get path which should be followed after session is succesfully updated
					#
					def session_updated_path
						ric_user_public.session_path
					end

					# 
					# Never trust parameters from the scary internet, only allow the white list through.
					#
					def session_params
						params.require(:session)
					end

				end
			end
		end
	end
end
