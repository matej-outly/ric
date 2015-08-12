# *****************************************************************************
# * Copyright (c) Clockstar s.r.o. All rights reserved.
# *****************************************************************************
# *
# * Engine
# *
# * Author: Matěj Outlý
# * Date  : 13. 5. 2015
# *
# *****************************************************************************

module RicAssortment
	class AdminEngine < ::Rails::Engine
		
		#
		# Controllers
		#
		require 'ric_assortment/concerns/controllers/admin/products_controller'
		require 'ric_assortment/concerns/controllers/admin/product_attachments_controller'
		require 'ric_assortment/concerns/controllers/admin/product_attachment_bindings_controller'
		require 'ric_assortment/concerns/controllers/admin/product_categories_controller'
		require 'ric_assortment/concerns/controllers/admin/product_category_bindings_controller'
		require 'ric_assortment/concerns/controllers/admin/product_photos_controller'
		
		isolate_namespace RicAssortment

		#
		# Load admin specific routes
		#
		initializer :set_ric_assortment_admin_routes, after: :set_routes_reloader_hook do
			config_path = File.expand_path(File.dirname(__FILE__) + "/../../config")
			require config_path + "/admin_routes.rb"
		end

	end
end
