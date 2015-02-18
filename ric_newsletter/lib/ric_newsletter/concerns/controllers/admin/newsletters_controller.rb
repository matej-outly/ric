# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Newsletters
# *
# * Author: Matěj Outlý
# * Date  : 16. 2. 2015
# *
# *****************************************************************************

module RicNewsletter
	module Concerns
		module Controllers
			module Admin
				module NewslettersController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do
					
						#
						# Set newsletter before some actions
						#
						before_action :set_newsletter, only: [:show, :edit, :update, :destroy]

					end

					#
					# Index action
					#
					def index
						@newsletters = RicNewsletter.newsletter_model.order(created_at: :desc).page(params[:page])
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
						@newsletter = RicNewsletter.newsletter_model.new
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
						@newsletter = RicNewsletter.newsletter_model.new(newsletter_params)
						if @newsletter.save
							redirect_to admin_newsletter_path(@newsletter), notice: I18n.t("activerecord.notices.models.#{RicNewsletter.newsletter_model.model_name.i18n_key}.create")
						else
							render "new"
						end
					end

					#
					# Update action
					#
					def update
						if @newsletter.update(newsletter_params)
							redirect_to admin_newsletter_path(@newsletter), notice: I18n.t("activerecord.notices.models.#{RicNewsletter.newsletter_model.model_name.i18n_key}.update")
						else
							render "edit"
						end
					end

					#
					# Destroy action
					#
					def destroy
						@newsletter.destroy
						redirect_to admin_newsletters_path, notice: I18n.t("activerecord.notices.models.#{RicNewsletter.newsletter_model.model_name.i18n_key}.destroy")
					end

				protected

					# *********************************************************************
					# Model setters
					# *********************************************************************
					
					def set_newsletter
						@newsletter = RicNewsletter.newsletter_model.find_by_id(params[:id])
						if @newsletter.nil?
							redirect_to admin_newsletters_path, error: I18n.t("activerecord.errors.models.#{RicNewsletter.newsletter_model.model_name.i18n_key}.not_found")
						end
					end

					# *********************************************************************
					# Param filters
					# *********************************************************************

					# 
					# Never trust parameters from the scary internet, only allow the white list through.
					#
					def newsletter_params
						params.require(:newsletter).permit(:subject, :content)
					end

				end
			end
		end
	end
end
