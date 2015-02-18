class CreateRicCustomerCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      
      # Timestamps
      t.timestamps

      # Identification
      t.string :first_name
      t.string :last_name

      # Contact information
      t.string :email
      t.string :phone
      
    end
  end
end
