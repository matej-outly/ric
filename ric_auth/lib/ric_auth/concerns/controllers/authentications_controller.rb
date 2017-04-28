# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Authentications
# *
# * Author: Matěj Outlý
# * Date  : 24. 3. 2017
# *
# *****************************************************************************

module RicAuth
	module Concerns
		module Controllers
			module AuthenticationsController extend ActiveSupport::Concern

				included do
				
				end

				def create
					auth = request.env["omniauth.auth"]
					
					# Email
					if auth.info.blank? || auth.info.email.blank?
						raise "Please provide auth e-mail."
					end

					authentication = RicAuth.authentication_model.find_by(
						provider: auth.provider, 
						uid: auth.uid
					)
					if authentication 

						# There is a valid authentication already created. Just find user and 
						# sign it in (regardless if it is already signed in)
						
						authentication.update(
							provider: auth.provider, 
							uid: auth.uid,
							oauth_token: (auth.credentials ? auth.credentials.token : nil),
							oauth_expires_at: (auth.credentials ? Time.at(auth.credentials.expires_at) : nil),
						)
						sign_in(:user, authentication.user)
						flash[:notice] = I18n.t("devise.sessions.user.signed_in")
						redirect_to after_sign_in_path_for(:user)
					
					elsif current_user

						# Valid authentication does not exists but there is already signed user.
						# So we can associate this authentication with this signed user.

						current_user.authentications.create(
							provider: auth.provider, 
							uid: auth.uid,
							oauth_token: (auth.credentials ? auth.credentials.token : nil),
							oauth_expires_at: (auth.credentials ? Time.at(auth.credentials.expires_at) : nil),
						)
						flash[:notice] = I18n.t("devise.sessions.user.signed_in")
						redirect_to after_sign_in_path_for(:user)
					
					else

						user = RicAuth.user_model.find_by(email: auth.info.email)
						if user 

							# User with this email aleady exists in DB. We can accociate it with
							# this credential and sign it in.

							user.authentications.create(
								provider: auth.provider, 
								uid: auth.uid,
								oauth_token: (auth.credentials ? auth.credentials.token : nil),
								oauth_expires_at: (auth.credentials ? Time.at(auth.credentials.expires_at) : nil),
							)
							sign_in(:user, user)
							flash[:notice] = I18n.t("devise.sessions.user.signed_in")
							redirect_to after_sign_in_path_for(:user)

						else

							# User with this email does not exists in DB. We can create a new user
							# and associate it with this credential and sign it in.

							user = RicAuth.user_model.create(email: auth.info.email)
							if user.valid?
								user.authentications.create(
									provider: auth.provider, 
									uid: auth.uid,
									oauth_token: (auth.credentials ? auth.credentials.token : nil),
									oauth_expires_at: (auth.credentials ? Time.at(auth.credentials.expires_at) : nil),
								)
								sign_in(:user, user)
								flash[:notice] = I18n.t("devise.sessions.user.signed_in")
								redirect_to after_sign_in_path_for(:user)
							else
								flash[:alert] = I18n.t("devise.failure.user.unknown")
								redirect_to after_sign_out_path_for(:user)
							end

						end
					end
				end

				def destroy
					if current_user
						current_user.authentications.where(provider: params[:provider]).destroy_all
						flash[:notice] = I18n.t("devise.sessions.user.signed_out")
					else
						flash[:notice] = I18n.t("devise.sessions.user.already_signed_out")
					end
					redirect_to after_sign_out_path_for(:user)
				end

			protected


			end
		end
	end
end