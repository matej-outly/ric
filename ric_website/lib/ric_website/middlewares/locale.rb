# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Recognize locale based on request
# *
# * Author: Matěj Outlý
# * Date  : 22. 7. 2015
# *
# *****************************************************************************

module RicWebsite
	module Middlewares
		class Locale
			
			#
			# Constructor
			#
			def initialize(app)
				@app = app	
			end

			#
			# Request
			#
			def call(env)
				if filter(env)
					return @app.call(env)
				else
					
					# Match locale from path
					match = /^\/(#{I18n.available_locales.join("|")})\//.match(env["PATH_INFO"] + "/")
					if match
						locale = match[1].to_sym
					else
						locale = nil
					end
					
					# Set correct locale and define default locale for URLs
					I18n.locale = locale || I18n.default_locale
					Rails.application.routes.default_url_options[:locale] = (I18n.default_locale == I18n.locale ? nil : I18n.locale )
					
					return @app.call(env)
				end
			end

		protected

			def filter(env)
				return true if env["PATH_INFO"].start_with?("/assets/")
				return false
			end

		end
	end
end