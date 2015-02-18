module RicNewsletter
	class Engine < ::Rails::Engine
		
		#
		# Models
		#
		require 'ric_newsletter/concerns/models/newsletter'
		require 'ric_newsletter/concerns/models/sent_newsletter'
		require 'ric_newsletter/concerns/models/sent_newsletter_customer'
		
		#
		# Controllers
		#
		require 'ric_newsletter/concerns/controllers/admin/newsletters_controller'
		require 'ric_newsletter/concerns/controllers/admin/sent_newsletters_controller'
		
		#
		# Mailers
		#
		require 'ric_newsletter/concerns/mailers/newsletter_mailer'
		
		#
		# Namespace
		#
		isolate_namespace RicNewsletter
	end
end
