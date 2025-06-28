class Blogger < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable,
        :jwt_authenticatable, jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Null

  has_many :blogs
  has_many :blog_likes
  has_many :comments
  has_many :saved_blogs, dependent: :destroy
  has_many :saved_blog_posts, through: :saved_blogs, source: :blog

  def self.ransackable_associations(auth_object = nil)
    ["blog_likes", "blogs"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "email", "encrypted_password", "id", "id_value", "remember_created_at", "reset_password_sent_at", "reset_password_token", "updated_at", "username", "comments_id_eq"]
  end
end

# == Schema Information
#
# Table name: bloggers
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  username               :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_bloggers_on_email                 (email) UNIQUE
#  index_bloggers_on_reset_password_token  (reset_password_token) UNIQUE
#
