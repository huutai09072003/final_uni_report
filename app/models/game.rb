class Game < ApplicationRecord
  has_many :images
  has_one_attached :featured_image
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
