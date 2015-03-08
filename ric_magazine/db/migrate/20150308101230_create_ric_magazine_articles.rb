class CreateRicMagazineArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|

      # Timestamps
      t.timestamps null: false
      t.datetime :published_at

      # Content
      t.string :title
      t.text :perex
      t.text :content

      # Meta
      t.string :keywords
      t.string :description

      # Persons
      t.integer :publisher_id
      t.string :authors
      t.string :garantors

      # Statistics
      t.integer :impresions, null: false, default: 0
      t.integer :readings, null: false, default: 0

    end
  end
end
