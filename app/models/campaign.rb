class Campaign < ApplicationRecord
  belongs_to :founder, class_name: 'Subscriber'
  has_many :participants
  has_many :subscribers, through: :participants
  has_many :donations

  has_one_attached :thumbnail

  enum status: {
    pending: 'pending',
    approved: 'approved',
    rejected: 'rejected'
  }, _prefix: true, _default: "pending"

  def self.ransackable_associations(auth_object = nil)
    %w[founder participants subscribers]
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[
      id
      title
      description
      goal
      location
      status
      is_get_donated
      thumb_nail_url
      created_at
      updated_at
      founder_id
      donations_id_eq
      thumbnail_attachment_id_eq
      thumbnail_blob_id_eq
    ]
  end

  # validates :title, :description, presence: true

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
# Table name: campaigns
#
#  id             :bigint           not null, primary key
#  description    :text
#  goal           :string
#  is_get_donated :boolean
#  location       :string
#  status         :string
#  thumb_nail_url :string
#  title          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  founder_id     :bigint
#
# Indexes
#
#  index_campaigns_on_founder_id  (founder_id)
#
# Foreign Keys
#
#  fk_rails_...  (founder_id => subscribers.id)
#
