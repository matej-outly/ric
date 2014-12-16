class CreateRicAdvertAdvertisers < ActiveRecord::Migration
  def change
    create_table :advertisers do |t|
      
      # Timestamps
      t.timestamps

      # Identification
      t.string :name
      
    end
  end
end
