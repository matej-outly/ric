# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Text
# *
# * Author: Matěj Outlý
# * Date  : 13. 5. 2015
# *
# *****************************************************************************

module RicWebsite
	module Concerns
		module Models
			module Text extend ActiveSupport::Concern

				#
				# 'included do' causes the included code to be evaluated in the
				# context where it is included, rather than being executed in 
				# the module's context.
				#
				included do
					
					# *********************************************************
					# Structure
					# *********************************************************

					#
					# Relation to page blocks
					#
					has_many :page_blocks, class_name: RicWebsite.page_block_model.to_s, as: :subject

					# *********************************************************
					# Localization
					# *********************************************************

					if RicWebsite.localization
						localized_column :title
						localized_column :content
					end

				end

				module ClassMethods

					#
					# Columns
					#
					def permitted_columns
						result = []
						[:title, :content].each do |column|
							if RicWebsite.localization
								I18n.available_locales.each do |locale|
									result << "#{column.to_s}_#{locale.to_s}".to_sym
								end
							else
								result << column
							end
						end
						[:key].each do |column|
							result << column
						end
						return result
					end

				end

				#
				# Get content formatted for public
				#
				def content_formatted
					result = self.content
					if config(:partials)
						config(:partials).each do |key, partial|
							result = result.gsub("{" + key.to_s + "}", render_partial(partial))
						end
					end
					return result
				end

			protected

				#
				# Render partial view
				#
				def render_partial(partial)
					return ActionView::Base.new(Rails.configuration.paths["app/views"]).render(
						partial: partial, 
						formats: [:html],
						handlers: [:erb]
					)
				end

			end
		end
	end
end