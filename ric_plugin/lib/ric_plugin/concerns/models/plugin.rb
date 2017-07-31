# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Plugin
# *
# * Author: Matěj Outlý
# * Date  : 1. 7. 2017
# *
# *****************************************************************************

module RicPlugin
	module Concerns
		module Models
			module Plugin extend ActiveSupport::Concern

				included do

					# *********************************************************
					# Structure
					# *********************************************************

					has_many :actor_relations, foreign_key: :actor_id, class_name: RicPlugin.plugin_relation_model.to_s, dependent: :destroy
					has_many :actee_relations, foreign_key: :actee_id, class_name: RicPlugin.plugin_relation_model.to_s, dependent: :destroy
					has_and_belongs_to_many :subjects, class_name: RicPlugin.subject_model.to_s, join_table: :plugins_subjects

				end

				module ClassMethods

					

				end

			end
		end
	end
end