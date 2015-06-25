# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Texts
# *
# * Author: Matěj Outlý
# * Date  : 13. 5. 2015
# *
# *****************************************************************************

module RicWebsite
	module Concerns
		module Controllers
			module Admin
				module TextsController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do
					
						#
						# Set text before some actions
						#
						before_action :set_text, only: [:show, :edit, :update, :destroy]

					end

					#
					# Index action
					#
					def index
						@texts = RicWebsite.text_model.all.order(created_at: :asc).page(params[:page]).per(50)
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
						@text = RicWebsite.text_model.new
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
						@text = RicWebsite.text_model.new(text_params)
						if @text.save
							redirect_to text_path(@text), notice: I18n.t("activerecord.notices.models.#{RicWebsite.text_model.model_name.i18n_key}.create")
						else
							render "new"
						end
					end

					#
					# Update action
					#
					def update
						if @text.update(text_params)
							redirect_to text_path(@text), notice: I18n.t("activerecord.notices.models.#{RicWebsite.text_model.model_name.i18n_key}.update")
						else
							render "edit"
						end
					end

					#
					# Destroy action
					#
					def destroy
						@text.destroy
						redirect_to texts_path, notice: I18n.t("activerecord.notices.models.#{RicWebsite.text_model.model_name.i18n_key}.destroy")
					end

				protected

					def set_text
						@text = RicWebsite.text_model.find_by_id(params[:id])
						if @text.nil?
							redirect_to texts_path, alert: I18n.t("activerecord.errors.models.#{RicWebsite.text_model.model_name.i18n_key}.not_found")
						end
					end

					# 
					# Never trust parameters from the scary internet, only allow the white list through.
					#
					def text_params
						params.require(:text).permit(:key, :title, :content, :keywords, :description)
					end

				end
			end
		end
	end
end
