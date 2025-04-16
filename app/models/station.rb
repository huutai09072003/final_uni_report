class Station < ApplicationRecord
  has_secure_password
end

# == Schema Information
#
# Table name: stations
#
#  id              :bigint           not null, primary key
#  location        :string
#  name            :string
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
