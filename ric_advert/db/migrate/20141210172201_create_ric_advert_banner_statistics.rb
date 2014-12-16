class CreateRicAdvertBannerStatistics < ActiveRecord::Migration
  def change
    create_table :banner_statistics do |t|
      
      # Timestamps
      t.timestamps

      # Relation to banner
      t.integer :banner_id

      # Statistics
      t.string :ip
      t.integer :impressions, null: false, default: 0
      t.integer :clicks, null: false, default: 0

    end
  end
end
