# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Authorization
# *
# * Author: Matěj Outlý
# * Date  : 1. 7. 2017
# *
# *****************************************************************************

module RicAcl
	module Concerns
		module Authorization extend ActiveSupport::Concern

			module ClassMethods
				
				def authorize(params = {})
					if params[:user]
						user = params[:user]
					else
						raise "Please define user." 
					end

					# User / roles
					if user.nil? # User not set => use roles for unsigned users
						role_ids = RicAcl.role_model.where(default_unsigned: true).map { |role| role.id }
						user_id = nil
					else # User set (signed in)
						role_ids = user.role_ids
						user_id = user.id
					end

					# End if no privilege owner to check
					return false if user_id.nil? && role_ids.empty?

					# Check privileges owned by user or some of the user's role
					sql = %{
						SELECT COUNT("privileges".*) AS "count"
						FROM "privileges"
						WHERE 
							("privileges"."subject_type" = 'Node' AND "privileges"."subject_id" = #{self.id}) AND
							(
								#{!role_ids.empty? ? "(\"privileges\".\"owner_type\" = 'Role' AND \"privileges\".\"owner_id\" IN (" + role_ids.join(",") + "))" : ""}
								#{!role_ids.empty? && !user_id.nil? ? "OR" : ""}
								#{!user_id.nil? ? "(\"privileges\".\"owner_type\" = 'User' AND \"privileges\".\"owner_id\" = " + user_id.to_s + ")" : ""}
							) AND
							("privileges"."action" = '#{action}')
					}
					privilege_count = self.class.connection.execute(sql).first["count"].to_i
					return true if privilege_count > 0

					return false
				end

				def authorize!(params = {})
					if !authorize(params)
						raise "Not authorized."
					end
				end

			end

		end
	end
end