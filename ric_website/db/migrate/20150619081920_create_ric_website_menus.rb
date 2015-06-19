class CreateRicWebsiteMenus < ActiveRecord::Migration
	def change
		create_table :menus do |t|

			t.timestamps null: true

			# Identification
			t.string :key
			t.string :name

		end
		create_table :menus_pages, id: false do |t|

			t.timestamps null: true

			# Bind
			t.integer :menu_id
			t.integer :page_id

		end
	end
end
