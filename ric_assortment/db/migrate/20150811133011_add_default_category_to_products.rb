class AddDefaultCategoryToProducts < ActiveRecord::Migration
	def change
		add_column :products, :default_product_category_id, :integer
	end
end
