# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Messages
# *
# * Author: Matěj Outlý
# * Date  : 19. 2. 2017
# *
# *****************************************************************************

module RicInmail
	module Concerns
		module Controllers
			module MessagesController extend ActiveSupport::Concern

				#
				# 'included do' causes the included code to be evaluated in the
				# context where it is included, rather than being executed in 
				# the module's context.
				#
				included do
				end

				def index
				end

				def show
				end

				def new
				end

				def edit
				end

				def create
				end

				def update
				end

				def destroy
				end

			end
		end
	end
end