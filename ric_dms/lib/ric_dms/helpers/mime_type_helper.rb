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
					'image' => 'fa-file-image-o',
					'audio' => 'fa-file-audio-o',
					'video' => 'fa-file-video-o',
					# Documents
					'application/pdf' => 'fa-file-pdf-o',
					'application/msword' => 'fa-file-word-o',
					'application/vnd.ms-word' => 'fa-file-word-o',
					'application/vnd.oasis.opendocument.text' => 'fa-file-word-o',
					'application/vnd.openxmlformats-officedocument.wordprocessingml' => 'fa-file-word-o',
					'application/vnd.ms-excel' => 'fa-file-excel-o',
					'application/vnd.openxmlformats-officedocument.spreadsheetml' => 'fa-file-excel-o',
					'application/vnd.oasis.opendocument.spreadsheet' => 'fa-file-excel-o',
					'application/vnd.ms-powerpoint' => 'fa-file-powerpoint-o',
					'application/vnd.openxmlformats-officedocument.presentationml' => 'fa-file-powerpoint-o',
					'application/vnd.oasis.opendocument.presentation' => 'fa-file-powerpoint-o',
					'text/plain' => 'fa-file-text-o',
					'text/html' => 'fa-file-code-o',
					'application/json' => 'fa-file-code-o',
					# Archives
					'application/gzip' => 'fa-file-archive-o',
					'application/zip' => 'fa-file-archive-o',
				}

				icon_classes.each do |mime_type, icon_class|
					if content_type.start_with?(mime_type)
						return icon_class
					end
				end

				return "fa-file-o"
			end

		end
	end
end
