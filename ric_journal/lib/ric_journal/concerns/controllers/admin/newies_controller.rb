# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Newies
# *
# * Author: Matěj Outlý
# * Date  : 30. 6. 2015
# *
# *****************************************************************************

module RicJournal
	module Concerns
		module Controllers
			module Admin
				module NewiesController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do
					
						#
						# Set newie before some actions
						#
						before_action :set_newie, only: [:show, :edit, :update, :destroy]

					end

					#
					# Index action
					#
					def index
						@newies = RicJournal.newie_model.all.order(published_at: :desc).page(params[:page]).per(50)
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
						@newie = RicJournal.newie_model.new
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
						@newie = RicJournal.newie_model.new(newie_params)
						if @newie.save
							redirect_to ric_journal_admin.newie_path(@newie), notice: I18n.t("activerecord.notices.models.#{RicJournal.newie_model.model_name.i18n_key}.create")
						else
							render "new"
						end
					end

					#
					# Update action
					#
					def update
						if @newie.update(newie_params)
							redirect_to ric_journal_admin.newie_path(@newie), notice: I18n.t("activerecord.notices.models.#{RicJournal.newie_model.model_name.i18n_key}.update")
						else
							render "edit"
						end
					end

					#
					# Destroy action
					#
					def destroy
						@newie.destroy
						redirect_to ric_journal_admin.newies_path, notice: I18n.t("activerecord.notices.models.#{RicJournal.newie_model.model_name.i18n_key}.destroy")
					end

				protected

					def set_newie
						@newie = RicJournal.newie_model.find_by_id(params[:id])
						if @newie.nil?
							redirect_to ric_journal_admin.newies_path, alert: I18n.t("activerecord.errors.models.#{RicJournal.newie_model.model_name.i18n_key}.not_found")
						end
					end

					# 
					# Never trust parameters from the scary internet, only allow the white list through.
					#
					def newie_params
						params.require(:newie).permit(:title, :perex, :content, :published_at)
					end

				end
			end
		end
	end
end
