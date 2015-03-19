class CreateRicRollingUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|

      # Timestamps
      t.timestamps null: true
      t.datetime :atuhenticated_at

      # Soft authentication
      t.string :pin

      # Hard authentication
      t.string :email
      t.string :encrypted_password

    end
  end
end
