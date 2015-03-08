# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Article
# *
# * Author: Matěj Outlý
# * Date  : 8. 3. 2015
# *
# *****************************************************************************

module RicMagazine
	class Article < ActiveRecord::Base
		include RicMagazine::Concerns::Models::Article
	end
end
