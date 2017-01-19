class CreateRicWebsiteFieldValues < ActiveRecord::Migration
	def change
		create_table :field_values do |t|
			t.timestamps null: true

			# Ordering
			t.integer  :position, index: true
			
			# Relations
			t.integer  :field_id, index: true
			t.integer  :node_id, index: true
			
			# Identification
			t.string   :ref, index: true
			t.string   :name
			t.string   :locale

			# Kind
			t.string   :kind
			t.integer  :enum_id, index: true

			# URL
			t.boolean  :include_in_url
			t.string   :slug, index: true

			# Value
			t.string   :value_string
			t.text     :value_text
			t.boolean  :value_boolean
			t.integer  :value_integer
			t.float    :value_float
			t.date     :value_date
			t.datetime :value_datetime
			t.string   :value_enum
			#t.string   :value_enum_array
			t.integer  :value_belongs_to
			#t.string   :value_has_many
			
		end
	end
end
