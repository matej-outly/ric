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
			module Public
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
						before_action :set_text, only: [:show]

					end

					#
					# Show action
					#
					def show
					end

				protected

					def set_text
						@text = RicWebsite.text_model.find_by_id(params[:id])
						if @text.nil?
							redirect_to texts_path, error: I18n.t("activerecord.errors.models.#{RicWebsite.text_model.model_name.i18n_key}.not_found")
						end
					end

				end
			end
		end
	end
end
