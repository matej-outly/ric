# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Stagable
# *
# * Author: Matěj Outlý
# * Date  : 31. 10. 2017
# *
# *****************************************************************************

module RicStaging
	module Concerns
		module Models
			module Stagable extend ActiveSupport::Concern

				included do
				
					# *********************************************************
					# Structure
					# *********************************************************

					has_many :stages, class_name: RicStaging.stage_model.to_s, as: :subject, dependent: :destroy

				end

				#
				# Get or build valid stage object
				#
				def stage(locale = nil)
					if @stage.nil?
						if locale
							@stage = self.stages.where(locale: locale).order(created_at: :desc).first
						else
							@stage = self.stages.order(created_at: :desc).first
						end
						if @stage.nil?
							@stage = self.stages.build(
								stage: "none",
								locale: locale	
							)
							#@stage.save
						end
					end
					return @stage
				end

				#
				# Get dominant stage filtered by given locales
				#
				def dominant_stage(locales = nil)
					if @dominant_stage.nil?
						if locales.is_a?(Array)
							checked_stages = self.stages.where(locale: locales)
						else
							checked_stages = self.stages
						end
						@dominant_stage = nil
						available_stage_values = RicStaging.stage_model.available_stages.map { |o| o.value.to_sym }
						checked_stages.each do |checked_stage|
							if @dominant_stage.nil? || available_stage_values.index(@dominant_stage.stage.to_sym) < available_stage_values.index(checked_stage.stage.to_sym)
								@dominant_stage = checked_stage
							end
						end
						if @dominant_stage.nil?
							@dominant_stage = self.stages.build(
								stage: "none"
							)
						end
					end
					return @dominant_stage
				end
			
			end
		end
	end
end