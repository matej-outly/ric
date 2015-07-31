# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Events calendar
# *
# * Author: Matěj Outlý
# * Date  : 31. 7. 2015
# *
# *****************************************************************************

class RicJournal::EventsCalendarComponent < RugController::Component

	def control
		today = Date.today
		prev_monday = today - (today.cwday - 1).days
		next_monday = prev_monday + 1.week
		@events = RicJournal.event_model.held(prev_monday, next_monday).order(held_at: :desc)
	end

end