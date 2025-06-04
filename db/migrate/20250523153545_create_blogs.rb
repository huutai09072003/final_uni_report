class CreateBlogs < ActiveRecord::Migration[7.2]
  def change
    create_table :blogs do |t|
      t.string :title
      t.text :content
      t.string :status
      t.string :thumb_nail_url
      t.integer :view_count
      t.integer :likes_count
      t.datetime :published_at
      t.references :blogger, null: false, foreign_key: true

      t.timestamps
    end
  end
end
