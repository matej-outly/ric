class CreateRicCustomerCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      
      # Timestamps
      t.timestamps null: true

      # Identification
      t.string :name_firstname
      t.string :name_lastname

      # Contact information
      t.string :email
      t.string :phone
      
    end
  end
end
