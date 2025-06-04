class CreateBlogLikes < ActiveRecord::Migration[7.2]
  def change
    create_table :blog_likes do |t|
      t.references :blog, null: false, foreign_key: true
      t.references :blogger, null: false, foreign_key: true

      t.timestamps
    end

    add_index :blog_likes, [:blog_id, :blogger_id], unique: true
  end
end
