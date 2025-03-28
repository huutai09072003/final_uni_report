class Waste < ApplicationRecord
  belongs_to :user
end

# == Schema Information
#
# Table name: wastes
#
#  id         :bigint           not null, primary key
#  image      :string
#  status     :string
#  type       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_wastes_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
