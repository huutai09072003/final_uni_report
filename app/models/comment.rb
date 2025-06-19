class Comment < ApplicationRecord
  belongs_to :blog
  belongs_to :blogger
  validates :content, presence: true, length: { minimum: 1 }

  def self.ransackable_associations(auth_object = nil)
    ["blog", "blogger"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["blog_id", "blogger_id", "content", "created_at", "id", "id_value", "updated_at"]
  end
end

# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  blog_id    :bigint           not null
#  blogger_id :bigint           not null
#
# Indexes
#
#  index_comments_on_blog_id     (blog_id)
#  index_comments_on_blogger_id  (blogger_id)
#
# Foreign Keys
#
#  fk_rails_...  (blog_id => blogs.id)
#  fk_rails_...  (blogger_id => bloggers.id)
#
