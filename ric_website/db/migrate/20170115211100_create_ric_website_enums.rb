class CreateRicWebsiteEnums < ActiveRecord::Migration
	def change
		create_table :enums do |t|
			t.timestamps null: true

			# Identification
			t.string :name
			t.string :ref

			# Values
			t.hstore :values

		end
	end
end
