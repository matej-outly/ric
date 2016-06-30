# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Checksum helper functions
# *
# * Author: Matěj Outlý
# * Date  : 29. 6. 2016
# *
# *****************************************************************************

module RicPaymentFerbuy
	class Backend
		class Checksum

			QUERY_ARGS = [
				"site_id",
				"reference",
				"currency",
				"amount",
				"first_name",
				"last_name",
			]

			NOTIFICATION_ARGS = [
				"reference",
				"transaction_id",
				"status",
				"currency",
				"amount",
			]

			#
			# Returns checksum to authenticate the query.
			#
			def self.query(data, options = {})
				result = []
				result << Config.env
				QUERY_ARGS.each do |key|
					if data[key].blank?
						return nil
					end
					result << data[key]
				end
				result << Config.secret
				return self.hash_function(result.join("&"))
			end

			#
			# Returns checksum to authenticate the notification.
			#
			def self.notification(data, options = {})
				result = []
				result << Config.env
				NOTIFICATION_ARGS.each do |key|
					if data[key].blank?
						return nil
					end
					result << data[key]
				end
				result << Config.secret
				return self.hash_function(result.join("&"))
			end
			
		protected

			#
			# Function that calculates hash
			#
			def self.hash_function(str)
				return Digest::SHA1.hexdigest(str)
			end

		end
	end
end

