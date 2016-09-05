# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Sessions
# *
# * Author: Matěj Outlý
# * Date  : 12. 11. 2015
# *
# *****************************************************************************

module RicAuth
	module Concerns
		module Controllers
			module Admin
				module SessionsController extend ActiveSupport::Concern

					#
					# 'included do' causes the included code to be evaluated in the
					# context where it is included, rather than being executed in 
					# the module's context.
					#
					included do
					
						prepend_before_action :require_no_authentication, only: [:new, :create]
						#prepend_before_action :allow_params_authentication!, only: :create
						prepend_before_action :verify_signed_out_user, only: :destroy
						#prepend_before_action only: [:create, :destroy] { request.env["devise.skip_timeout"] = true }

					end

					def new
						@user = RicAuth.user_model.new
						clean_up_passwords(@user)
						#respond_with(resource, serialize_options(resource))
					end

					def create
						@user = warden.authenticate!(auth_options)
						#set_flash_message!(:notice, :signed_in)
						#sign_in(resource_name, resource)
						#respond_with resource, location: after_sign_in_path_for(resource)
					end

					def destroy
						signed_out = sign_out
						flash[:notice] = I18n.t("activerecord.notices.models.#{RicAuth.user_model.model_name.i18n_key}.signed_out") if signed_out
						redirect_to after_sign_out_path_for(resource_name)
					end

				protected

					def resource
						@user
					end

					def resource_name
						"user"	
					end

					def require_no_authentication
						authenticated = warden.authenticated?(resource_name)
						if authenticated && resource = warden.user(resource_name)
							flash[:alert] = I18n.t("activerecord.errors.models.#{RicAuth.user_model.model_name.i18n_key}.already_authenticated")
							redirect_to after_sign_in_path_for(current_user)
						end
					end

					def sign_in_params

						devise_parameter_sanitizer.sanitize(:sign_in)
					end

					def serialize_options(resource)
						methods = resource_class.authentication_keys.dup
						methods = methods.keys if methods.is_a?(Hash)
						methods << :password if resource.respond_to?(:password)
						{ methods: methods, only: [:password] }
					end

					def auth_options
						{ scope: resource_name, recall: "#{controller_path}#new" }
					end

					def translation_scope
						'devise.sessions'
					end

					def clean_up_passwords(object)
						object.clean_up_passwords if object.respond_to?(:clean_up_passwords)
					end

					def verify_signed_out_user
						if all_signed_out?
							flash[:notice] = I18n.t("activerecord.notices.models.#{RicAuth.user_model.model_name.i18n_key}.already_signed_out")
							redirect_to after_sign_out_path_for(resource_name)
						end
					end

					def all_signed_out?
						users = Devise.mappings.keys.map { |s| warden.user(scope: s, run_callbacks: false) }
						users.all?(&:blank?)
					end

				end
			end
		end
	end
end