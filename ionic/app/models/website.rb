class Website < ActiveRecord::Base
  # Association
  belongs_to :user
  has_many :collections

  # Friendly ID
  extend FriendlyId
  friendly_id :name, use: :slugged
end
