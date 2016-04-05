# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Signature computation
# *
# * Author: Matěj Outlý
# * Date  : 4. 4. 2016
# *
# *****************************************************************************

module RicPaymentThepay
	class Backend
		class DataApi
			class Signature

				#
				# Compute signature
				#
				def self.compute(data)
					
					# Delete signature from data if defined
					data.delete("signature")

					# Add password
					data["password"] = Config.data_api_password

					# So far only single level supported
					return process_single_level(data)
				end

				#
				# Joins data into one param string and hash it via hash function
				# 
				def self.process_single_level(data)
					parts = []
					data.each do |key, value|
						parts << (key.to_s + "=" + value.to_s)
					end
					joined = parts.join("&")
					hashed = hash_function(joined)
					return hashed
				end
			
			protected

				#
				# Function that calculates hash
				#
				def self.hash_function(str)
					return Digest::SHA256.hexdigest(str)
				end

			end
		end
	end
end