RicNewsletter::Engine.routes.draw do

	#
	# Admin
	#
	namespace :admin do
		
		# Newsletters
		resources :newsletters

	    # Sent newsletters
	    resources :sent_newsletters, only: [:new, :create, :destroy] do
	    	member do
	    		get 'resend'
	    	end
	    end

	end

end
