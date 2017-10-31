# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Stages
# *
# * Author: Matěj Outlý
# * Date  : 31. 10. 2017
# *
# *****************************************************************************

module RicStaging
	module Concerns
		module Controllers
			module StagesController extend ActiveSupport::Concern

				included do
					
					# Set some models before actions
					before_action :set_subject
					before_action :set_locale

				end

				def transit
					@stage = @subject.stage(@locale)
					if RicStaging.stage_model.available_stages.map { |o| o.value.to_sym }.include?(params[:to].to_sym)
						@stage.stage = params[:to]
						if @stage.save
							respond_to do |format|
								format.html { redirect_to request.referrer, notice: RicStaging.stage_model.human_notice_message(:update) }
								format.json { render json: @subject.id }
							end
						else
							error = true
						end
					else
						error = true
					end
					if error
						respond_to do |format|
							format.html { redirect_to request.referrer, alert: RicStaging.stage_model.human_error_message(:update) }
							format.json { render json: false }
						end
					end
				end

			protected
				
				def set_subject
					if params[:subject_id] && params[:subject_type]
						@subject_type = params[:subject_type].constantize rescue nil
						@subject = @subject_type.find_by_id(params[:subject_id]) if @subject_type
						not_found if @subject.nil?
					else
						not_found
					end
				end

				def set_locale
					if params[:locale]
						@locale = params[:locale].to_sym
						not_found if !I18n.available_locales.include?(@locale)
					else
						@locale = nil
					end
				end

			end
		end
	end
end
