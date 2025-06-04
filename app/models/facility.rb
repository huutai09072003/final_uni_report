class Facility < ApplicationRecord
  has_and_belongs_to_many :sections

  enum category: {
    recycling: 'recycling',
    repair: 'repair',
    waste_management: 'waste_management',
    bins: 'bins',
    apps: 'apps'
  }, _prefix: true

  def self.ransackable_associations(auth_object = nil)
    %w[sections]
  end

    def self.ransackable_attributes(auth_object = nil)
    ["category", "created_at", "id", "id_value", "link", "name", "updated_at"]
  end
end

# == Schema Information
#
# Table name: facilities
#
#  id         :bigint           not null, primary key
#  category   :string
#  link       :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
