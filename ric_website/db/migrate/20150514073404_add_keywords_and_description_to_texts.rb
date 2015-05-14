class AddKeywordsAndDescriptionToTexts < ActiveRecord::Migration
	def change
		add_column :texts, :keywords, :string
		add_column :texts, :description, :string
	end
end
