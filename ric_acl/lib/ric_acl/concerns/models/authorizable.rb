# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Authorizable model
# *
# * Author: Matěj Outlý
# * Date  : 3. 7. 2017
# *
# *****************************************************************************

module RicAcl
	module Concerns
		module Models
			module Authorizable extend ActiveSupport::Concern

				module ClassMethods

					# *********************************************************
					# Simple authorization
					# *********************************************************

					def authorize(params = {})
						params[:subject] = self
						return RicAcl.authorize(params)
					end

					def authorize!(params = {})
						params[:subject] = self
						return RicAcl.authorize!(params)
					end

					# *********************************************************
					# Authorization scope definition
					# *********************************************************

					def authorization_scopes
						@authorization_scopes = {} if @authorization_scopes.nil?
						return @authorization_scopes
					end

					def authorization_scope_query(scope, &block)
						self.authorization_scopes[scope.to_sym] = {} if self.authorization_scopes[scope.to_sym].nil?
						self.authorization_scopes[scope.to_sym][:query] = block
					end

					def authorization_scope_setter(scope, &block)
						self.authorization_scopes[scope.to_sym] = {} if self.authorization_scopes[scope.to_sym].nil?
						self.authorization_scopes[scope.to_sym][:setter] = block
					end

					# *********************************************************
					# Authorization scope usage
					# *********************************************************

					def authorized_for(params = {})
						raise "Please define user." if !params[:user]
						raise "Please define scope." if !params[:scope]
						raise "Authorization scope not defined." if !self.authorization_scopes[params[:scope].to_sym] || !self.authorization_scopes[params[:scope].to_sym][:query]
						return self.instance_exec(params[:user], &self.authorization_scopes[params[:scope].to_sym][:query]) # ???
					end

				end

				# *************************************************************
				# Simple authorization
				# *************************************************************

				def authorize(params = {})
					params[:subject] = self
					return RicAcl.authorize(params)
				end

				def authorize!(params = {})
					params[:subject] = self
					return RicAcl.authorize!(params)
				end

				# *************************************************************
				# Authorization scope usage
				# *************************************************************

				def authorize_for(params = {})
					raise "Please define user." if !params[:user]
					raise "Please define scope." if !params[:scope]
					raise "Authorization scope not defined." if !self.authorization_scopes[params[:scope].to_sym] || !self.authorization_scopes[params[:scope].to_sym][:setter]
					return self.instance_exec(params[:user], &self.authorization_scopes[params[:scope].to_sym][:setter])
				end

			end
		end
	end
end