# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Product attachment
# *
# * Author: Matěj Outlý
# * Date  : 8. 7. 2015
# *
# *****************************************************************************

module RicAssortment
	module Concerns
		module Models
			module ProductAttachment extend ActiveSupport::Concern

				#
				# 'included do' causes the included code to be evaluated in the
				# conproduct where it is included, rather than being executed in 
				# the module's conproduct.
				#
				included do
					
					# *********************************************************
					# Structure
					# *********************************************************

					has_and_belongs_to_many :products, class_name: RicAssortment.product_model.to_s

					# *********************************************************
					# Ordering
					# *********************************************************
					
					enable_ordering
					
					# *********************************************************
					# File
					# *********************************************************

					has_attached_file :file
					validates_attachment :file, content_type: { content_type: /\Aapplication\/.*\Z/ }

					before_save :set_title_if_empty

				end

				module ClassMethods

					# *********************************************************
					# Scopes
					# *********************************************************

					def search(query)
						if query.blank?
							all
						else
							if config(:disable_unaccent) == true
								where_string = "(lower(title) LIKE ('%' || lower(trim(:query)) || '%'))"
							else
								where_string = "(lower(unaccent(title)) LIKE ('%' || lower(unaccent(trim(:query))) || '%'))"
							end
							where(where_string, query: query)
						end
					end

				end

				def set_title_if_empty
					if self.title.blank?
						self.title = file_file_name
					end
				end

			end
		end
	end
end