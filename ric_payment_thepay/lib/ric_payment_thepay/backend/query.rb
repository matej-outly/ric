# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Query helper functions
# *
# * Author: Matěj Outlý
# * Date  : 13. 4. 2016
# *
# *****************************************************************************

module RicPaymentThepay
	class Backend
		class Query

			#
			# Returns signature to authenticate the query. The signature
			# consists of hash of all specified parameters and the merchant
			# password specified in the configuration. So no one can alter the
			# payment, because the password is not known.
			#
			def self.signature(data, options = {})
				result = ""
				data.each do |key, value|
					if options[:filter_signature] == false || !value.blank?
						if options[:escape_signature] == false
							result += key.to_s + "=" + self.stringify(value) + "&"
						else
							result += self.escape(key.to_s) + "=" + self.escape(self.stringify(value)) + "&"
						end
					end
				end
				if options[:escape_signature] == false
					result += "password=" + Config.password
				else
					result += "password=" + self.escape(Config.password)
				end
				return self.hash_function(result)
			end

			#
			# Build the query part of the URL from data.
			#
			def self.build(data, options = {})
				if options[:signature_data].nil?
					signature_data = data
				else
					signature_data = options[:signature_data]
				end
				result = []
				all_data = data.merge({"signature" => self.signature(signature_data, options)})
				all_data.each do |key, value|
					result << (self.escape(key.to_s) + "=" + self.escape(self.stringify(value)))
				end
				join_string = "&"
				join_string = options[:join_string] if options[:join_string]
				return result.join(join_string)
			end
			
		protected

			#
			# Function that calculates hash
			#
			def self.hash_function(str)
				return Digest::MD5.hexdigest(str)
			end

			#
			# Escape string correctly
			#
			def self.escape(str)
				return CGI.escape(str).gsub("+", "%20")
			end

			#
			# Make correct string from value
			#
			def self.stringify(value)
				if value == true
					return "1"
				elsif value == false
					return "0"
				else
					return value.to_s
				end
			end

		end
	end
end

