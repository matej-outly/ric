# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Organization
# *
# * Author: Matěj Outlý
# * Date  : 31. 7. 2017
# *
# *****************************************************************************

module RicOrganization
	module Concerns
		module Models
			module Organization extend ActiveSupport::Concern

				included do
					
					# *********************************************************
					# Structure
					# *********************************************************

					# Organization assignments
					if RicOrganization.enable_organization_assignments
						has_many :organization_assignments, class_name: RicOrganization.organization_assignment_model.to_s, dependent: :destroy
					end

					# User assignments
					if RicOrganization.enable_user_assignments
						has_many :user_assignments, class_name: RicOrganization.user_assignment_model.to_s, dependent: :destroy
						has_many :assigned_users, class_name: RicOrganization.user_model.to_s, through: :user_assignments, source: :user
					end

					if RicOrganization.enable_organization_relations
						
						# Relations which are my actors
						has_many :actor_relations, foreign_key: :actee_id, class_name: RicOrganization.organization_relation_model.to_s, dependent: :destroy
						has_many :actor_organizations, class_name: RicOrganization.organization_model.to_s, through: :actor_relations, source: :actor
						
						# Relations which are my actees
						has_many :actee_relations, foreign_key: :actor_id, class_name: RicOrganization.organization_relation_model.to_s, dependent: :destroy
						has_many :actee_organizations, class_name: RicOrganization.organization_model.to_s, through: :actee_relations, source: :actee
					
					end

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
								(lower(unaccent(name)) LIKE ('%' || lower(unaccent(trim(:query))) || '%'))
							", query: query.to_s)
						end
					end

					# *********************************************************
					# Columns
					# *********************************************************

					def permitted_columns
						result = [
							:name
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

			end
		end
	end
end