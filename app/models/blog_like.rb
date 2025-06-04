class BlogLike < ApplicationRecord
  belongs_to :blog
  belongs_to :blogger

  validates :blog_id, uniqueness: { scope: :blogger_id }

  def self.ransackable_attributes(auth_object = nil)
    ["blog_id", "blogger_id", "created_at", "id", "updated_at"]
  end
end

# == Schema Information
#
# Table name: blog_likes
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  blog_id    :bigint           not null
#  blogger_id :bigint           not null
#
# Indexes
#
#  index_blog_likes_on_blog_id                 (blog_id)
#  index_blog_likes_on_blog_id_and_blogger_id  (blog_id,blogger_id) UNIQUE
#  index_blog_likes_on_blogger_id              (blogger_id)
#
# Foreign Keys
#
#  fk_rails_...  (blog_id => blogs.id)
#  fk_rails_...  (blogger_id => bloggers.id)
#
