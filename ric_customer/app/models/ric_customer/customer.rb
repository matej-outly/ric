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
		# Search
		# *********************************************************************

		#define_search_column :first_name, :string, [:like, :llike, :rlike], form_method: :text_input_row, form_method_params: [:text_field]

		# *********************************************************************
		# Statistics
		# *********************************************************************

		#define_statistic :sample_stat, { :sample_bound => { form_method: :text_input_row, form_method_params: [:number_field] } } do |params|
		#	where("sample_count >= #{params[:sample_bound].to_i}")
		#end
		
	end
end
