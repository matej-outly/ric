# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Slugged attachment
# *
# * Author: Matěj Outlý
# * Date  : 9. 10. 2017
# *
# *****************************************************************************

module RicAttachment
	module Concerns
		module Models
			module SluggedAttachment extend ActiveSupport::Concern

			protected

				def _url_original
					"/attachments/#{self.id}"
				end
				
				def _generate_slug(slug_model, locale)
					if !self.file_file_name.blank? && self.subject && self.subject.respond_to?(:compose_slug_translation)
						filter, translation = self.subject.compose_slug_translation(locale)
						translation = translation + "/" + self.file_file_name
						slug_model.add_slug(locale, URI.parse(self.url_original).path, translation, filter)
					else
						slug_model.remove_slug(locale, URI.parse(self.url_original).path)
					end
				end

				def _destroy_slug(slug_model, locale)
					slug_model.remove_slug(locale, URI.parse(self.url_original).path)
				end

				def _destroy_slug_was(slug_model, locale)
					# Original URL did not change since it is derived from attachment ID
				end

			end
		end
	end
end