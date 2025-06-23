class Blog < ApplicationRecord
  belongs_to :blogger
  has_many :blog_likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :saved_blogs, dependent: :destroy
  has_many :saved_by_bloggers, through: :saved_blogs, source: :blogger

  has_one_attached :thumbnail

  enum status: {
    pending: 'pending',
    approved: 'approved',
    rejected: 'rejected'
  }, _prefix: true, _default: "pending"

  validates :title, :content, presence: true

  def self.ransackable_associations(auth_object = nil)
    ["blog_likes", "blogger"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["blogger_id", "content", "created_at", "id", "id_value", "likes_count", "published_at", "status", "thumb_nail_url", "title", "updated_at", "view_count", 
    "comments_id_eq", "thumbnail_attachment_id_eq", "thumbnail_blob_id_eq"]
  end

  def thumbnail_url
    if thumbnail.attached?
      Rails.application.routes.url_helpers.rails_blob_url(thumbnail)
    else
      thumb_nail_url
    end
  end
end

# == Schema Information
#
# Table name: blogs
#
#  id             :bigint           not null, primary key
#  content        :text
#  likes_count    :integer
#  published_at   :datetime
#  status         :string
#  thumb_nail_url :string
#  title          :string
#  view_count     :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  blogger_id     :bigint           not null
#
# Indexes
#
#  index_blogs_on_blogger_id  (blogger_id)
#
# Foreign Keys
#
#  fk_rails_...  (blogger_id => bloggers.id)
#
