# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Data API request
# *
# * Author: Matěj Outlý
# * Date  : 4. 4. 2016
# *
# *****************************************************************************

module RicPaymentThepay
	class Backend
		class DataApi
			class Request

				#
				# Create response object matching the specific request
				#
				def response_factory
					raise "Method not implemented."
				end

				#
				# Get operation identifier - to be implemented in child classes
				#
				def operation
					raise "Method not implemented."
				end

				# *************************************************************
				# Data
				# *************************************************************

				#
				# Get all request specific data - to be implemented in child classes
				#
				def specific_data
					raise "Method not implemented."
				end

				#
				# Get all common data
				#
				def common_data
					result = {}
					result["merchantId"] = Config.merchant_id
					return result
				end

				#
				# Get all data (combined common and specific)
				#
				def combined_data
					return self.common_data.merge(self.specific_data)
				end

				#
				# Get all data including signature
				#
				def data
					return self.combined_data.merge({"signature" => self.signature})
				end

				# *************************************************************
				# Signature
				# *************************************************************

				#
				# Get signature computed based on the current data
				#
				def signature
					return Signature.compute(self.combined_data)
				end

			end
		end
	end
end