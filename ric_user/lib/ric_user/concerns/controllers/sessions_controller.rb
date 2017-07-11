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
			module SessionsController extend ActiveSupport::Concern

				included do
				
					before_action :set_session_soft, only: [:show]
					before_action :set_session_hard, only: [:edit, :update]

				end

				def show
					respond_to do |format|
						format.html { render "show" }
						format.json { render json: @session.to_json }
					end
				end

				def edit
					#puts request.referrer.inspect
					#puts ric_user_public.edit_session_url.inspect
					store_return_path(request.referrer)
				end

				def update
					store_return_path(request.referrer) if request.referrer != ric_user_public.edit_session_url
					if @session.update(session_params)
						respond_to do |format|
							format.html { redirect_to (stored_return_path || session_updated_path), notice: I18n.t("activerecord.notices.models.#{RicUser.session_model.model_name.i18n_key}.update") }
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

				# *************************************************************
				# Model setters
				# *************************************************************

				def set_session_soft
					@session = RicUser.session_model.find(RicUser.session_model.current_id(session))
				end

				def set_session_hard
					@session = RicUser.session_model.find_or_create(RicUser.session_model.current_id(session))
				end

				# *************************************************************
				# Param filters
				# *************************************************************

				def session_params
					params.require(:session) # To be defined...
				end

				# *************************************************************
				# Session
				# *************************************************************

				def session_key
					return "session"
				end

				def store_return_path(return_path)
					session[session_key] = {} if session[session_key].nil?
					session[session_key]["return_path"] = return_path
				end

				def stored_return_path
					if !session[session_key].nil? && !session[session_key]["return_path"].nil?
						return session[session_key]["return_path"]
					else
						return nil
					end
				end

				def session_updated_path
					ric_user_public.session_path
				end

			end
		end
	end
end
