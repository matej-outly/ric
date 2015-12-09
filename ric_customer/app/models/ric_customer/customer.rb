# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Customer
# *
# * Author: Matěj Outlý
# * Date  : 10. 12. 2014
# *
# *****************************************************************************

module RicCustomer
	class Customer < ActiveRecord::Base
		include RicCustomer::Concerns::Models::Customer

		# *********************************************************************
		# Filter
		# *********************************************************************

		#define_filter_column :first_name, :string, [:like, :llike, :rlike]

		# *********************************************************************
		# Statistics
		# *********************************************************************

		#define_statistic :sample_stat, { :sample_bound => { type: :integer } } do |params|
		#	where("sample_count >= #{params[:sample_bound].to_i}")
		#end
		
	end
end
