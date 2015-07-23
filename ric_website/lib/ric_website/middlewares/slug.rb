# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Request translation based on DB slugs
# *
# * Author: Matěj Outlý
# * Date  : 21. 7. 2015
# *
# *****************************************************************************

module RicWebsite
	module Middlewares
		class Slug
			
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
						locale = match[1]
					else
						locale = nil
					end

					# Remove locale from path
					if locale
						translation = env["PATH_INFO"][(1+locale.length)..-1]
					else
						translation = env["PATH_INFO"]
					end

					# Translate to original and modify request
					original = RicWebsite.slug_model.translation_to_original(I18n.locale, translation)
					if !original.nil?
						original = "/" + locale + original if locale
						env["REQUEST_PATH"] = original
						env["PATH_INFO"] = original
						env["REQUEST_URI"] = original + "?" + env["QUERY_STRING"]
					end
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