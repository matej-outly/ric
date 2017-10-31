class CreateRicStagingStages < ActiveRecord::Migration
	def change
		create_table :stages do |t|
			t.timestamps null: true
			t.integer :subject_id, index: true
			t.string :subject_type, index: true
			t.string :stage
			t.string :locale, index: true
		end
	end
end
