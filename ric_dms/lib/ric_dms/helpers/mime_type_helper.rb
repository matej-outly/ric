# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Mime-type helper
# *
# * Author:
# * Date  : 21. 2. 2017
# *
# *****************************************************************************

module RicDms
	module Helpers
		module MimeTypeHelper

			def mime_type_fa_icon(content_type)
				icon_classes = {
					# Media
					'image' => 'fa-file-image',
					'audio' => 'fa-file-audio',
					'video' => 'fa-file-video',
					# Documents
					'application/pdf' => 'fa-file-pdf',
					'application/msword' => 'fa-file-word',
					'application/vnd.ms-word' => 'fa-file-word',
					'application/vnd.oasis.opendocument.text' => 'fa-file-word',
					'application/vnd.openxmlformats-officedocument.wordprocessingml' => 'fa-file-word',
					'application/vnd.ms-excel' => 'fa-file-excel',
					'application/vnd.openxmlformats-officedocument.spreadsheetml' => 'fa-file-excel',
					'application/vnd.oasis.opendocument.spreadsheet' => 'fa-file-excel',
					'application/vnd.ms-powerpoint' => 'fa-file-powerpoint',
					'application/vnd.openxmlformats-officedocument.presentationml' => 'fa-file-powerpoint',
					'application/vnd.oasis.opendocument.presentation' => 'fa-file-powerpoint',
					'text/plain' => 'fa-file-text',
					'text/html' => 'fa-file-code',
					'application/json' => 'fa-file-code',
					# Archives
					'application/gzip' => 'fa-file-archive',
					'application/zip' => 'fa-file-archive',
				}

				icon_classes.each do |mime_type, icon_class|
					if content_type.start_with?(mime_type)
						return icon_class
					end
				end

				return "fa-file"
			end

		end
	end
end
