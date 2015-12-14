class AddPersonToRicUserUsers < ActiveRecord::Migration
	def change
		add_column :users, :person_id, :integer
		add_column :users, :person_type, :string
	end
end
