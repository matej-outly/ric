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
	end
end
