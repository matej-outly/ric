class CreateRicUserUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|

      # Timestamps
      t.timestamps null: false

      # Basic identification
      t.string :email

    end
  end
end
