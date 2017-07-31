class CreateRicOrganizationOrganizations < ActiveRecord::Migration
	def change
		create_table :organizations do |t|

			t.timestamps null: true
			
			# Name
			t.string :name

		end
	end
end
