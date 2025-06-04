class StripeAccount < ApplicationRecord
  belongs_to :subscriber

  validates :stripe_account_id, presence: true
end

# == Schema Information
#
# Table name: stripe_accounts
#
#  id                :bigint           not null, primary key
#  account_type      :string
#  country           :string
#  details_submitted :boolean
#  status            :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  stripe_account_id :string
#  subscriber_id     :bigint           not null
#
# Indexes
#
#  index_stripe_accounts_on_subscriber_id  (subscriber_id)
#
# Foreign Keys
#
#  fk_rails_...  (subscriber_id => subscribers.id)
#
