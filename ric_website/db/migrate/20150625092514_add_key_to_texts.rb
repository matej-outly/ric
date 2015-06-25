class AddKeyToTexts < ActiveRecord::Migration
	def change
		add_column :texts, :key, :string
	end
end
