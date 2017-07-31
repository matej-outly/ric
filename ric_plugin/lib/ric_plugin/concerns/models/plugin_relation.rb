# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Plugin relation
# *
# * Author: Matěj Outlý
# * Date  : 1. 7. 2017
# *
# *****************************************************************************

module RicPlugin
	module Concerns
		module Models
			module PluginRelation extend ActiveSupport::Concern

				included do

					# *********************************************************
					# Structure
					# *********************************************************

					belongs_to :actor, class_name: RicPlugin.plugin_model.to_s
					belongs_to :actee, class_name: RicPlugin.plugin_model.to_s

					# *********************************************************
					# Kind
					# *********************************************************
					
					enum_column :kind, [:dependency, :exclusion]
					
				end

				module ClassMethods

					

				end

			end
		end
	end
end