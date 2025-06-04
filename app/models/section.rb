class Section < ApplicationRecord
  has_many :items, dependent: :destroy
  has_and_belongs_to_many :facilities

  def self.ransackable_associations(auth_object = nil)
    ["facilities", "items"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "id", "id_value", "name", "updated_at"]
  end
end

# == Schema Information
#
# Table name: sections
#
#  id          :bigint           not null, primary key
#  description :text
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
