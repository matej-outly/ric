# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Articles
# *
# * Author: Matěj Outlý
# * Date  : 8. 3. 2015
# *
# *****************************************************************************

module RicMagazine
	module Concerns
		module Controllers
			module Admin
				module ArticlesController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do
					
						#
						# Set article before some actions
						#
						before_action :set_article, only: [:show, :edit, :update, :destroy]

					end

					#
					# Index action
					#
					def index
						@articles = RicMagazine.article_model.all.order(published_at: :desc, created_at: :desc).page(params[:page]).per(50)
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
						@article = RicMagazine.article_model.new
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
						@article = RicMagazine.article_model.new(article_params)
						@article.publisher = RicMagazine.user_model.current
						if @article.save
							redirect_to article_path(@article), notice: I18n.t("activerecord.notices.models.#{RicMagazine.article_model.model_name.i18n_key}.create")
						else
							render "new"
						end
					end

					#
					# Update action
					#
					def update
						if @article.update(article_params)
							redirect_to article_path(@article), notice: I18n.t("activerecord.notices.models.#{RicMagazine.article_model.model_name.i18n_key}.update")
						else
							render "edit"
						end
					end

					#
					# Destroy action
					#
					def destroy
						@article.destroy
						redirect_to articles_path, notice: I18n.t("activerecord.notices.models.#{RicMagazine.article_model.model_name.i18n_key}.destroy")
					end

				protected

					def set_article
						@article = RicMagazine.article_model.find_by_id(params[:id])
						if @article.nil?
							redirect_to articles_path, alert: I18n.t("activerecord.errors.models.#{RicMagazine.article_model.model_name.i18n_key}.not_found")
						end
					end

					# 
					# Never trust parameters from the scary internet, only allow the white list through.
					#
					def article_params
						params.require(:article).permit(:published_at, :title, :perex, :content, :keywords, :description, :authors, :garantors)
					end

				end
			end
		end
	end
end
