class CreateSavedBlogs < ActiveRecord::Migration[7.2]
  def change
    create_table :saved_blogs do |t|
      t.references :blogger, null: false, foreign_key: true
      t.references :blog, null: false, foreign_key: true

      t.timestamps
    end

    add_index :saved_blogs, [:blogger_id, :blog_id], unique: true, name: 'index_saved_blogs_on_blogger_and_blog'
  end
end
