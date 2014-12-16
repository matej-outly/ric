module RicAdvert
	class Engine < ::Rails::Engine
		
		#
		# Models
		#
		require 'ric_advert/concerns/models/advertiser'
		require 'ric_advert/concerns/models/banner'
		require 'ric_advert/concerns/models/banner_statistic'
		
		#
		# Controllers
		#
		require 'ric_advert/concerns/controllers/admin/advertisers_controller'
		require 'ric_advert/concerns/controllers/admin/banners_controller'
		require 'ric_advert/concerns/controllers/observer/advertisers_controller'
		require 'ric_advert/concerns/controllers/observer/banners_controller'
		require 'ric_advert/concerns/controllers/public/banners_controller'

		#
		# Namespace
		#
		isolate_namespace RicAdvert
	end
end
