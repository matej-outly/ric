class AddBackgroundToPages < ActiveRecord::Migration
	def change
		add_attachment :pages, :background
	end
end
