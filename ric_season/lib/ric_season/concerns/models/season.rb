# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Season
# *
# * Author: Matěj Outlý
# * Date  : 22. 4. 2016
# *
# *****************************************************************************

module RicSeason
	module Concerns
		module Models
			module Season extend ActiveSupport::Concern

				#
				# 'included do' causes the included code to be evaluated in the
				# context where it is included, rather than being executed in 
				# the module's context.
				#
				included do
					
					# *********************************************************
					# Validators
					# *********************************************************

					#
					# Dates
					#
					validates :name, :from, :to, presence: true

					# *********************************************************
					# Current
					# *********************************************************

					#
					# Current cache must be cleared after each safe to be always up to date
					#
					after_save :clear_current_cache
					after_save :disable_current_for_other_seasons

					# *********************************************************
					# Dates
					# *********************************************************

					#
					# Automatically normalize and compute missing dates
					# 
					before_validation :normalize_date_from
					before_validation :compute_date_to

				end

				module ClassMethods

					#
					# Columns
					#
					def permitted_columns
						result = []
						[:name, :from, :to, :current].each do |column|
							result << column
						end
						return result
					end

					# *********************************************************
					# Current
					# *********************************************************
					
					#
					# Get current season
					#
					def current
						@current = where(current: true).order(from: :desc).first if @current.nil?
						return @current
					end

					#
					# Get last season
					#
					def last
						@last = where("#{ActiveRecord::Base.connection.quote_column_name("from")} < ?", current.from).order(from: :desc).first if @last.nil?
						return @last
					end

					#
					# Get next season
					#
					def next
						@next = where("#{ActiveRecord::Base.connection.quote_column_name("from")} > ?", current.from).order(from: :asc).first if @next.nil?
						return @next
					end

					#
					# Get current, last and next seasons
					#
					def current_and_last_and_next
						return [self.current, self.last, self.next]
					end
					
					#
					# Get current and last seasons
					#
					def current_and_last
						return [self.current, self.last]
					end

					#
					# Get current and next seasons
					#
					def current_and_next
						return [self.current, self.next]
					end

					#
					# Get last and next seasons
					#
					def last_and_next
						return [self.last, self.next]
					end

					#
					# Clear current cache
					#
					def clear_current_cache
						@current = nil
						@last = nil
						@next = nil
					end

					# *********************************************************
					# Search scope
					# *********************************************************

					def search(query)
						if query.blank?
							all
						else
							if config(:disable_unaccent) == true
								where_string = "
									(lower(name) LIKE ('%' || lower(trim(:query)) || '%'))
								"
							else
								where_string = "
									(lower(unaccent(name)) LIKE ('%' || lower(unaccent(trim(:query))) || '%'))
								"
							end
							where(where_string, query: query)
						end
					end

				end

				#
				# Get season period
				#
				def period
					config(:period)
				end

			protected

				# *************************************************************
				# Current
				# *************************************************************

				#
				# Clear current cache
				#
				def clear_current_cache
					self.class.clear_current_cache
				end

				#
				# Set current flag to false in all other seasons if this season is now current
				#
				def disable_current_for_other_seasons
					if self.current == true
						RicSeason.season_model.where("id <> ?", self.id).update_all(current: false)
					end
				end

				# *************************************************************
				# Dates
				# *************************************************************

				#
				# Automatically normalize date from
				# 
				def normalize_date_from
					start = config(:start)
					if start
						if self.period == "year"
							first_day = Date.parse("#{self.from.cwyear}-#{start}")
							if self.from < first_day
								self.from = first_day - 1.year
							else
								self.from = first_day
							end
						elsif self.period == "month"
							first_day = Date.parse("#{self.from.cwyear}-#{self.from.month}-#{start}")
							if self.from < first_day
								self.from = first_day - 1.month
							else
								self.from = first_day
							end
						end
					end
				end

				#
				# Automatically compute date to
				#
				def compute_date_to
					if self.period == "year"
						self.to = self.from + 1.year
					elsif self.period == "month"
						self.to = self.from + 1.month
					end
				end

			end
		end
	end
end