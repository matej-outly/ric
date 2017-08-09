# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Subject model
# *
# * Author: Matěj Outlý
# * Date  : 3. 7. 2017
# *
# *****************************************************************************

module RicPlugin
	module Concerns
		module Models
			module Subject extend ActiveSupport::Concern

				included do

					# *********************************************************
					# Structure
					# *********************************************************

					has_and_belongs_to_many :plugins, class_name: RicPlugin.plugin_model.to_s, join_table: :plugins_subjects, foreign_key: :subject_id

				end

				#
				# Decide if subject has some specific plugin activated
				#
				def plugin?(ref)
					
				end

				#
				# Get plugin specified by ref
				#
				def plugin(ref)
										
				end
				
			end
		end
	end
end