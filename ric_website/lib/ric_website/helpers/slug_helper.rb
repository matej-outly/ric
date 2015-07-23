# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Slug helper
# *
# * Author: Matěj Outlý
# * Date  : 22. 7. 2015
# *
# *****************************************************************************

module RicWebsite
	module Helpers
		module SlugHelper

			def self.slugify(path)

				# Match locale from path
				match = /^\/(#{I18n.available_locales.join("|")})\//.match(path + "/")
				if match
					locale = match[1]
				else
					locale = nil
				end

				# Remove locale from path
				if locale
					original = path[(1+locale.length)..-1]
				else
					original = path
				end

				# Translate from original
				tmp_uri = URI.parse(original)
				tmp_path = RicWebsite.slug_model.original_to_translation((locale ? locale : I18n.default_locale), tmp_uri.path)
				if tmp_path
					tmp_uri.path = tmp_path
					translation = tmp_uri.to_s
				else
					translation = original
				end

				# Add locale if defined
				translation = "/" + locale + translation if locale
				return translation
			end

			def slugify(path)
				return SlugHelper.slugify(path)
			end

		end
	end
end
