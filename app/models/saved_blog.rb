class SavedBlog < ApplicationRecord
  belongs_to :blogger
  belongs_to :blog

  validates :blogger_id, uniqueness: { scope: :blog_id }
end

# == Schema Information
#
# Table name: saved_blogs
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  blog_id    :bigint           not null
#  blogger_id :bigint           not null
#
# Indexes
#
#  index_saved_blogs_on_blog_id           (blog_id)
#  index_saved_blogs_on_blogger_and_blog  (blogger_id,blog_id) UNIQUE
#  index_saved_blogs_on_blogger_id        (blogger_id)
#
# Foreign Keys
#
#  fk_rails_...  (blog_id => blogs.id)
#  fk_rails_...  (blogger_id => bloggers.id)
#
