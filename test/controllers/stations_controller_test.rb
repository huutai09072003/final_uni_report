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
require "test_helper"

class StationsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get stations_index_url
    assert_response :success
  end
end
