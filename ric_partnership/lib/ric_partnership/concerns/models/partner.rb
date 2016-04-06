# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Partner
# *
# * Author: Matěj Outlý
# * Date  : 8. 3. 2015
# *
# *****************************************************************************

module RicPartnership
	module Concerns
		module Models
			module Partner extend ActiveSupport::Concern

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
					# Ordering
					#
					enable_ordering

					# *********************************************************
					# Attachments
					# *********************************************************

					#
					# Logo
					#
					has_attached_file :logo, :styles => { :full => config(:logo_crop, :full) }
					validates_attachment_content_type :logo, :content_type => /\Aimage\/.*\Z/

					# *********************************************************
					# Localization
					# *********************************************************

					if RicPartnership.localization
						localized_column :name
					end

				end

				module ClassMethods

					#
					# Columns
					#
					def permitted_columns
						result = []
						[:name].each do |column|
							if RicPartnership.localization
								I18n.available_locales.each do |locale|
									result << "#{column.to_s}_#{locale.to_s}".to_sym
								end
							else
								result << column
							end
						end
						[:url, :logo].each do |column|
							result << column
						end
						return result
					end

				end

			end
		end
	end
end