class Game < ApplicationRecord
  has_many :images

  def self.ransackable_associations(auth_object = nil)
    ["images"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "id", "id_value", "name", "updated_at"]
  end
end

# == Schema Information
#
# Table name: games
#
#  id          :bigint           not null, primary key
#  description :string
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
