class CreateRicAdvertAdvertisers < ActiveRecord::Migration
  def change
    create_table :advertisers do |t|
      
      # Timestamps
      t.timestamps null: false

      # Identification
      t.string :name
      
    end
  end
end
