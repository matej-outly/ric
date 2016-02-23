# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Dummy payment object
# *
# * Author: Matěj Outlý
# * Date  : 22. 2. 2016
# *
# *****************************************************************************

module RicPayment
	module Backends
		class Dummy
			class Payment

				# *************************************************************
				# Status
				# *************************************************************

				def status
					return :paid
				end

				def id
					return 1
				end

				# *************************************************************
				# Actions
				# *************************************************************

				def create
					return true
				end

				def confirm
					return true
				end

				def cancel
					return true
				end

			end
		end
	end
end