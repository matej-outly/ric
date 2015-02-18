class CreateRicNewsletterSentNewsletterCustomers < ActiveRecord::Migration
  def change
    create_table :sent_newsletter_customers do |t|

      # Timestamps
      t.timestamps
      t.datetime :sent_at

      # Binding
      t.integer :sent_newsletter_id
      t.integer :customer_id

      # Cache
      t.string :customer_email

    end
  end
end
