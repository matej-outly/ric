# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Locale helper
# *
# * Author: Matěj Outlý
# * Date  : 24. 7. 2015
# *
# *****************************************************************************

module RicUrl
	module Helpers
		module LocaleHelper

			def self.disassemble(path)
				# TODO work correctly with http:// and https:// links

				# Match locale from path
				match = /^\/(#{I18n.available_locales.join("|")})\//.match(path + "/")
				if match
					locale = match[1].to_sym
				else
					locale = nil
				end

				# Remove locale from path
				if locale
					path = path[(1+locale.to_s.length)..-1]
				end

				# Root
				if path.blank?
					path = "/"
				end
				
				return [locale, path]
			end

			def self.assemble(locale, path)
				if locale && (RicUrl.disable_default_locale || (I18n.default_locale.to_sym != locale.to_sym))
					if path == "/"
						path = "/" + locale.to_s
					else
						path = "/" + locale.to_s + path 
					end
				end
				return path
			end

			def self.localify(path)
				return path if path == "#"

				# Match locale from path
				locale, path = RicUrl::Helpers::LocaleHelper.disassemble(path)

				# Take current locale if path locale not defined
				if locale.nil?
					locale = I18n.locale
				end

				# Assemble back into path with locale
				path = RicUrl::Helpers::LocaleHelper.assemble(locale, path)

				return path
			end

			def localify(path)
				return LocaleHelper.localify(path)
			end

		end
	end
end