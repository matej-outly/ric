# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Branches map
# *
# * Author: Matěj Outlý
# * Date  : 30. 6. 2015
# *
# *****************************************************************************

class RicContact::BranchesMapComponent < RugController::Component

	def control
		@branches = RicContact.branch_model.all
	end

end