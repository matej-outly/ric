class CreateRicRollingUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|

      # Timestamps
      t.timestamps null: true

      # Authentication
      t.string :email
      t.string :encrypted_password

    end
  end
end
