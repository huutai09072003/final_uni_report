class Donation < ApplicationRecord
  belongs_to :campaign, optional: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :currency, inclusion: { in: %w[usd gbp eur] }
  validates :frequency, inclusion: { in: %w[once monthly annually] }
  validates :full_name, presence: true
  validates :stripe_session_id, presence: true, uniqueness: true
  validates :stripe_customer_id, presence: true

  enum status: {
    pending: 'pending',
    completed: 'completed'
  }, _default: 'pending', _prefix: true

  enum donation_type: {
    for_web: 'for_web',
    for_campaign: 'for_campaign'
  }, _default: 'for_web', _prefix: true
end

# == Schema Information
#
# Table name: donations
#
#  id                     :bigint           not null, primary key
#  amount                 :decimal(, )
#  currency               :string
#  donation_type          :string
#  frequency              :string
#  full_name              :string
#  include_name           :boolean
#  status                 :string
#  subscribe_newsletter   :boolean
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  campaign_id            :bigint
#  session_id             :string
#  stripe_customer_id     :string
#  stripe_payment_id      :string
#  stripe_session_id      :string
#  stripe_subscription_id :string
#
# Indexes
#
#  index_donations_on_campaign_id        (campaign_id)
#  index_donations_on_session_id         (session_id) UNIQUE
#  index_donations_on_stripe_session_id  (stripe_session_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (campaign_id => campaigns.id)
#
