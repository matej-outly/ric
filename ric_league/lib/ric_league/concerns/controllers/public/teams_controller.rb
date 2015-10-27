# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Teams
# *
# * Author: Matěj Outlý
# * Date  : 13. 3. 2015
# *
# *****************************************************************************

module RicLeague
	module Concerns
		module Controllers
			module Public
				module TeamsController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do
					
						#
						# Set team before some actions
						#
						before_action :set_team, only: [:show, :edit, :update, :destroy]

					end

					#
					# Index action
					#
					def index
						@teams = RicLeague.team_model.all.order(position: :asc).page(params[:page]).per(50)
					end

					#
					# Show action
					#
					def show
					end

				protected

					def set_team
						@team = RicLeague.team_model.find_by_id(params[:id])
						if @team.nil?
							redirect_to teams_path, alert: I18n.t("activerecord.errors.models.#{RicLeague.team_model.model_name.i18n_key}.not_found")
						end
					end

				end
			end
		end
	end
end
