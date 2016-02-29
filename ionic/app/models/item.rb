class Item < ActiveRecord::Base
  # Associations
  belongs_to :collection
  belongs_to :folder
  has_many :photos

  # Friendly ID
  extend FriendlyId
  friendly_id :name, use: :slugged
end
