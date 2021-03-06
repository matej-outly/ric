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

				included do
					
					# *********************************************************
					# Structure
					# *********************************************************

					enable_ordering

					# *********************************************************
					# Attachments
					# *********************************************************

					picture_column :logo, :styles => { :full => RicPartnership.partner_logo_crop[:full] }
					
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