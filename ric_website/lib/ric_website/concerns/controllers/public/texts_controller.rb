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
						before_action :set_text, only: [:show, :inline_edit, :inline_update]

					end

					#
					# Show action
					#
					def show
					end

					#
					# Inline edit action
					#
					def inline_edit
					end

					#
					# Inline update action
					#
					def inline_update
						@text.update(text_params)
						redirect_to text_path(@text), notice: I18n.t("activerecord.notices.models.#{RicWebsite.text_model.model_name.i18n_key}.update")
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
						if params[:text] && params[:text][@text.id]
							return params.params[:text][@text.id].permit(:title, :content)
						else
							return {}
						end
					end

				end
			end
		end
	end
end
