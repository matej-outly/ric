# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Checksum computation
# *
# * Author: Matěj Outlý
# * Date  : 29. 6. 2016
# *
# *****************************************************************************

module RicPaymentFerbuy
	class Backend
		class Api
			class Checksum

				ARGS = [
					"site_id",
					"transaction_id",
					"command",
					"output_type",
				]

				#
				# Compute signature
				#
				def self.compute(data)
					result = []
					ARGS.each do |key|
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
end