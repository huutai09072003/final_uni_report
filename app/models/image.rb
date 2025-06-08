class Image < ApplicationRecord
  has_one_attached :file
  belongs_to :game, optional: true

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "game_id", "id", "id_value", "name", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["game"]
  end
end

# == Schema Information
#
# Table name: images
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  game_id    :bigint
#
# Indexes
#
#  index_images_on_game_id  (game_id)
#
# Foreign Keys
#
#  fk_rails_...  (game_id => games.id)
#