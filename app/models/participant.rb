class Participant < ApplicationRecord
  belongs_to :subscriber
  belongs_to :campaign

  def self.ransackable_attributes(auth_object = nil)
    %w[
      id
      campaign_id
      subscriber_id
      created_at
      updated_at
    ]
  end
end

# == Schema Information
#
# Table name: participants
#
#  id            :bigint           not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  campaign_id   :bigint           not null
#  subscriber_id :bigint           not null
#
# Indexes
#
#  index_participants_on_campaign_id    (campaign_id)
#  index_participants_on_subscriber_id  (subscriber_id)
#
# Foreign Keys
#
#  fk_rails_...  (campaign_id => campaigns.id)
#  fk_rails_...  (subscriber_id => subscribers.id)
#
