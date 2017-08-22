# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Role
# *
# * Author: Matěj Outlý
# * Date  : 26. 11. 2015
# *
# *****************************************************************************

module RicUser
	module Concerns
		module Models
			module Role extend ActiveSupport::Concern

				included do

					# *********************************************************
					# Structure
					# *********************************************************

					has_many :user_roles, class_name: RicUser.user_role_model.to_s, dependent: :destroy
					has_many :users, class_name: RicUser.user_model.to_s, through: :user_roles
					#has_many :privileges, as: :owner, dependent: :destroy

					# *********************************************************
					# Validators
					# *********************************************************

					validates_presence_of :name, :ref

				end

				module ClassMethods
					
					# *********************************************************
					# Scopes
					# *********************************************************

					def search(query)
						if query.blank?
							all
						else
							where("
								(lower(unaccent(name)) LIKE ('%' || lower(unaccent(trim(:query))) || '%'))
							", query: query.to_s)
						end
					end

					def filter(params = {})
						
						# Preset
						result = all

						# name
						if !params[:name].blank?
							result = result.where("lower(unaccent(name)) LIKE ('%' || lower(unaccent(trim(?))) || '%')", params[:name].to_s)
						end
					
						result
					end

					# *********************************************************
					# Columns
					# *********************************************************
					
					def permitted_columns
						[
							:name,
							:ref,
							:description,
							:default_signed,
							:default_unsigned,
						]
					end

					def filter_columns
						[
							:name
						]
					end

				end

			end
		end
	end
end