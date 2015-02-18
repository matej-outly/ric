class CreateRicNewsletterNewsletters < ActiveRecord::Migration
  def change
    create_table :newsletters do |t|

      # Timestamps
      t.timestamps

      # Content
      t.string :subject
      t.text :content

    end
  end
end
