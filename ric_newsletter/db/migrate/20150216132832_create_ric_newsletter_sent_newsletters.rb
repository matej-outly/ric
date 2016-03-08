class CreateRicNewsletterSentNewsletters < ActiveRecord::Migration
  def change
    create_table :sent_newsletters do |t|

      # Timestamps
      t.timestamps null: true
      t.datetime :sent_at

      # Binding to newsletter
      t.integer :newsletter_id
      
      # Customers scope
      t.string :customers_scope
      t.string :customers_scope_params

      # Statistics
      t.integer :customers_count
      t.integer :sent_count

    end
  end
end
