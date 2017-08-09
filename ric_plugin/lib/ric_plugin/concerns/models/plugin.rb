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

					# *********************************************************
					# Scopes
					# *********************************************************

					def filter(params)
						
						# Preset
						result = all

						# Name
						if !params[:name].blank?
							result = result.where("lower(unaccent(name)) LIKE ('%' || lower(unaccent(trim(?))) || '%')", params[:name].to_s)
						end

						result
					end

					def search(query)
						if query.blank?
							all
						else
							where("
								(lower(unaccent(name)) LIKE ('%' || lower(unaccent(trim(:query))) || '%')) OR
								(lower(unaccent(ref)) LIKE ('%' || lower(unaccent(trim(:query))) || '%'))
							", query: query.to_s)
						end
					end

					# *********************************************************
					# Columns
					# *********************************************************

					def permitted_columns
						result = [
							:name,
							:ref
						]
						return result
					end

					def filter_columns
						result = [
							:name,
						]
						return result
					end

				end

				#
				# Make this plugin dependent on the given plugin
				#
				def depends_on!(plugin)
					self.actor_relations.find_or_create_by(kind: "depends_on", actee: plugin)
				end

				#
				# Get all plugins on which this plugin is dependent
				#
				def depends_on
					self.actor_relations.where(kind: "depends_on").map { |i| i.actee }
				end

				#
				# Make this plugin excluded by the given plugin
				#
				def excluded_by!(plugin)
					self.actor_relations.find_or_create_by(kind: "excluded_by", actee: plugin)
				end

				#
				# Get all plugins which excludes this module
				#
				def excluded_by
					self.actor_relations.where(kind: "excluded_by").map { |i| i.actee }
				end

			end
		end
	end
end