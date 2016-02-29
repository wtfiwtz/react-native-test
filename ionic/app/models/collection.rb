class Collection < ActiveRecord::Base

  include Heros

  # Associations
  belongs_to :website
  has_many :folders, as: :parent
  has_many :items
  has_one :hero, as: :item
  has_one :hero_photo, through: :hero, source: :photo

  # Friendly ID
  extend FriendlyId
  friendly_id :name, use: :slugged
end
