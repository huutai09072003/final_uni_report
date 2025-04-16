class Notification < ApplicationRecord
  belongs_to :user

  scope :unread, -> { where(read: false) }
end

# == Schema Information
#
# Table name: notifications
#
#  id         :bigint           not null, primary key
#  body       :string
#  read       :boolean
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_notifications_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
