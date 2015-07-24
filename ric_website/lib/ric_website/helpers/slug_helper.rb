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
				locale, original = RicWebsite::Helpers::LocaleHelper.disassemble(path)

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
				translation = RicWebsite::Helpers::LocaleHelper.assemble(locale, translation)
				
				return translation
			end

			def slugify(path)
				return SlugHelper.slugify(path)
			end

		end
	end
end
