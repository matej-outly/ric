# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Data API request
# *
# * Author: Matěj Outlý
# * Date  : 29. 6. 2016
# *
# *****************************************************************************

module RicPaymentFerbuy
	class Backend
		class Api
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
				# Attributes to be filled in child classes
				# *************************************************************
				
				#
				# Transaction ID
				#
				attr_accessor :transaction_id

				#
				# Command
				#
				attr_accessor :command
				
				# *************************************************************
				# Data
				# *************************************************************

				#
				# Get all data
				#
				def raw_data
					if self.transaction_id.blank? || self.command.blank?
						return nil
					end

					result = {}
					result["site_id"] = Config.site_id
					result["transaction_id"] = self.transaction_id 
					result["command"] = self.command
					result["output_type"] = "json"
					return result
				end

				#
				# Get all data including checksum
				#
				def data
					return self.raw_data.merge({"checksum" => self.checksum})
				end

				# *************************************************************
				# Checksum
				# *************************************************************

				#
				# Get checksum computed based on the current data
				#
				def checksum
					return Checksum.compute(self.raw_data)
				end

			end
		end
	end
end