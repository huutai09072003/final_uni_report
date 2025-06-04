class Item < ApplicationRecord
  belongs_to :section

  has_many :item_relationships
  has_many :related_items, through: :item_relationships, source: :related_item

  # Để tìm kiếm ngược lại (nếu cần):
  has_many :reverse_item_relationships, class_name: 'ItemRelationship', foreign_key: 'related_item_id'
  has_many :items_related_to_this, through: :reverse_item_relationships, source: :item

  def self.ransackable_attributes(auth_object = nil)
    %w[
      name
      description
      image_url
      life_cycle
      recycle_way
      can_recycle
      created_at
      updated_at
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[
      section
      item_relationships
      related_items
      reverse_item_relationships
      items_related_to_this
    ]
  end
end

# == Schema Information
#
# Table name: items
#
#  id          :bigint           not null, primary key
#  can_recycle :boolean
#  description :text
#  image_url   :string
#  life_cycle  :text
#  name        :string
#  recycle_way :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  section_id  :bigint           not null
#
# Indexes
#
#  index_items_on_section_id  (section_id)
#
# Foreign Keys
#
#  fk_rails_...  (section_id => sections.id)
#
