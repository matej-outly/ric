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
						before_action :set_session, only: [:show, :edit, :update]

					end

					#
					# Show action
					#
					def show
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
							redirect_to session_updated_path, notice: I18n.t("activerecord.notices.models.#{RicUser.session_model.model_name.i18n_key}.update")
						else
							render "edit"
						end
					end

				protected

					#
					# Set model
					#
					def set_session
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
