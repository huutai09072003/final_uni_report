class ItemRelationship  < ApplicationRecord
  belongs_to :item
  belongs_to :related_item, class_name: 'Item'

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "id_value", "item_id", "related_item_id", "updated_at"]
  end
end

# == Schema Information
#
# Table name: item_relationships
#
#  id              :bigint           not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  item_id         :bigint
#  related_item_id :bigint
#
# Indexes
#
#  index_item_relationships_on_item_id          (item_id)
#  index_item_relationships_on_related_item_id  (related_item_id)
#
# Foreign Keys
#
#  fk_rails_...  (item_id => items.id)
#  fk_rails_...  (related_item_id => items.id)
#
