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
		require "ric_assortment/concerns/controllers/admin/products_controller"
		require "ric_assortment/concerns/controllers/admin/product_categories_controller"
		require "ric_assortment/concerns/controllers/admin/product_pictures_controller"
		require "ric_assortment/concerns/controllers/admin/product_attachments_controller"
		require "ric_assortment/concerns/controllers/admin/products_product_attachments_controller"
		require "ric_assortment/concerns/controllers/admin/product_teasers_controller"
		require "ric_assortment/concerns/controllers/admin/product_manufacturers_controller"
		
		isolate_namespace RicAssortment

		#
		# Load admin specific routes
		#
		def reload_routes
			config_path = File.expand_path(File.dirname(__FILE__) + "/../../config")
			load(config_path + "/admin_routes.rb")
		end

	end
end
