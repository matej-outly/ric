RicAccount::Engine.routes.draw do

	# Account
	get   "account/user", to: "account#user"
	put   "account/user", to: "account#user_update"
	patch "account/user", to: "account#user_update"
	get   "account/password", to: "account#password"
	put   "account/password", to: "account#password_update"
	patch "account/password", to: "account#password_update"

end
