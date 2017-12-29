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
				
				def _authorize(params = {})
					if params[:user]
						user = params[:user]
					else
						raise "Please define user." 
					end
					if params[:action]
						action = params[:action]
					else
						raise "Please define action." 
					end
					if params[:subject]
						subject = params[:subject]
					else
						raise "Please define subject." 
					end
					if params[:scope]
						scope = params[:scope]
					else
						scope = nil
					end

					if subject.is_a?(ActiveRecord::Base) && scope
						
						# In this special case not scoped query is checked first. If success, 
						# user holds not scoped permissions for the class or object and no
						# other check is necessary. If failed, seconds try is performed with
						# respect to scope. If second try is success, additional check must 
						# be performed to ensure that given subject is in the scope of the given
						# user.

						sql = authorization_sql(subject, nil, user, action)
						return false if !sql
						privilege_count = ActiveRecord::Base.connection.execute(sql).first["count"].to_i
						if privilege_count > 0
							return true 
						else
							sql = authorization_sql(subject, scope, user, action)
							return false if !sql
							privilege_count = ActiveRecord::Base.connection.execute(sql).first["count"].to_i
							if privilege_count > 0
								authorized_subjects = subject.class.authorized_for(user: user, scope: scope)
								authorized_subjects = [authorized_subjects] if !authorized_subjects.is_a?(Array)
								authorized_subjects.each do |authorized_subjects_collection|
									if authorized_subjects_collection.find_by_id(subject.id)
										return true
									end
								end
							end
						end
					else

						# All other cases can be checked only once.

						sql = authorization_sql(subject, scope, user, action)
						return false if !sql
						privilege_count = ActiveRecord::Base.connection.execute(sql).first["count"].to_i
						return true if privilege_count > 0
					end

					return false
				end

				def authorize(params = {})
					deactivate_logging
					result = _authorize(params)
					activate_logging
					return result
				end

				def authorize!(params = {})
					not_authorized if !authorize(params)
				end

				def not_authorized
					raise "Not authorized."
				end

				def authorization_sql(subject, scope, user, action)

					# User / roles
					if user.nil? # User not set => use roles for unsigned users
						role_ids = RicAcl.role_model.where(default_unsigned: true).map { |role| role.id }
						user_id = nil
					else # User set (signed in)
						role_ids = user.role_ids
						user_id = user.id
					end

					# End if no privilege owner to check
					return nil if user_id.nil? && role_ids.empty?

					# Header
					sql = %{
						SELECT COUNT("privileges".*) AS "count"
						FROM "privileges"
						WHERE 
					}

					# Subject / scope
					if subject.class == Class 
						sql += %{
							("privileges"."subject_type" = '#{subject.to_s}') AND
						}
					elsif subject.is_a?(ActiveRecord::Base)
						sql += %{
							(
								("privileges"."subject_type" = '#{subject.class.to_s}') OR
								("privileges"."subject_type" = '#{subject.class.to_s}' AND "privileges"."subject_id" = #{subject.id})
							) AND
						}
					else
						raise "Unknown subject."
					end

					# Scope
					if scope
						if scope.is_a?(Array)
							sql += %{
								("privileges"."scope_type" IN (#{scope.map{ |s| "'" + s.to_s + "'" }.join(",")}) OR "privileges"."scope_type" IS NULL) AND
							}
						else
							sql += %{
								("privileges"."scope_type" = '#{scope.to_s}' OR "privileges"."scope_type" IS NULL) AND
							}
						end
					else
						sql += %{
							("privileges"."scope_type" IS NULL) AND
						}
					end

					# User / roles
					sql += %{
						(
							#{!role_ids.empty? ? "(\"privileges\".\"owner_type\" = '" + RicAcl.role_model.to_s + "' AND \"privileges\".\"owner_id\" IN (" + role_ids.join(",") + "))" : ""}
							#{!role_ids.empty? && !user_id.nil? ? "OR" : ""}
							#{!user_id.nil? ? "(\"privileges\".\"owner_type\" = '" + RicAcl.user_model.to_s + "' AND \"privileges\".\"owner_id\" = " + user_id.to_s + ")" : ""}
						) AND
					}

					# Action
					sql += %{
						("privileges"."action" = '#{action}')
					}

					return sql
				end

			protected

				# *************************************************************************
				# Logging
				# *************************************************************************
				
				def deactivate_logging
					@deactivated_logger = ActiveRecord::Base.logger
					ActiveRecord::Base.logger = nil
				end

				def activate_logging
					ActiveRecord::Base.logger = @deactivated_logger
					@deactivated_logger = nil
				end

				def deactivated_logger
					@deactivated_logger
				end

			end

		end
	end
end