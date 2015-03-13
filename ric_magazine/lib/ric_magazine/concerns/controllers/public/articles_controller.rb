# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Articles
# *
# * Author: Matěj Outlý
# * Date  : 13. 3. 2015
# *
# *****************************************************************************

module RicMagazine
	module Concerns
		module Controllers
			module Public
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
						@articles = RicMagazine.article_model.all.order(published_at: :desc, created_at: :desc).page(params[:page])
					end

					#
					# Show action
					#
					def show
					end

				protected

					def set_article
						@article = RicMagazine.article_model.find_by_id(params[:id])
						if @article.nil?
							redirect_to admin_articles_path, error: I18n.t("activerecord.errors.models.#{RicMagazine.article_model.model_name.i18n_key}.not_found")
						end
					end

				end
			end
		end
	end
end
