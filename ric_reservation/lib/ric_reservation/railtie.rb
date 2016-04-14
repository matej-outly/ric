# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Railtie for view helpers integration
# *
# * Author: Matěj Outlý
# * Date  : 14. 4. 2016
# *
# *****************************************************************************

module RicReservation
	class Railtie < Rails::Railtie
		initializer "ric_reservation.helpers" do
			ActionView::Base.send :include, Helpers::WeekTimetableHelper
			ActionView::Base.send :include, Helpers::MonthTimetableHelper
			ActionView::Base.send :include, Helpers::TimetablePaginationHelper
		end
	end
end