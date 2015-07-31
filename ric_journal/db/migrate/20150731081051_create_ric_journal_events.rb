class CreateRicJournalEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|

      t.timestamps null: true
      
      t.datetime :held_at
      t.string :title
      t.text :perex
      t.text :content
    end
  end
end
