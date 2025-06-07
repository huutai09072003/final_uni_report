class Subscriber < ApplicationRecord
  has_many :founded_campaigns, class_name: 'Campaign', foreign_key: 'founder_id'
  has_many :participants
  has_many :campaigns, through: :participants
  has_one :stripe_account, dependent: :destroy

  validates :full_name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  def self.ransackable_associations(auth_object = nil)
    ["campaigns", "founded_campaigns", "participants"]
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[
      id
      email
      full_name
      nickname
      phone_number
      created_at
      updated_at
      stripe_account_id_eq
    ]
  end
end

# == Schema Information
#
# Table name: subscribers
#
#  id           :bigint           not null, primary key
#  email        :string
#  full_name    :string
#  nickname     :string
#  phone_number :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
