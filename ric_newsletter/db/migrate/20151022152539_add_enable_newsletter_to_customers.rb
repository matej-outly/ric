class AddEnableNewsletterToCustomers < ActiveRecord::Migration
  def change
  	add_column :customers, :enable_newsletter, :boolean
  	add_column :customers, :newsletter_token, :string
  end
end
