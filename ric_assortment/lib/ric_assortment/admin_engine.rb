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
		require 'ric_assortment/concerns/controllers/admin/product_attachment_relations_controller'
		require 'ric_assortment/concerns/controllers/admin/product_categories_controller'
		require 'ric_assortment/concerns/controllers/admin/product_category_relations_controller'
		require 'ric_assortment/concerns/controllers/admin/product_panels_controller'
		require 'ric_assortment/concerns/controllers/admin/product_panel_sub_product_relations_controller'
		require 'ric_assortment/concerns/controllers/admin/product_photos_controller'
		require 'ric_assortment/concerns/controllers/admin/product_tickers_controller'
		require 'ric_assortment/concerns/controllers/admin/product_ticker_relations_controller'
		
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
