class Folder < ActiveRecord::Base

  include Heros

  # Associations
  belongs_to :collection
  has_many :items
  has_many :folders, as: :parent
  belongs_to :parent, polymorphic: true
  has_one :hero, as: :item
  has_one :hero_photo, through: :hero, source: :photo

  # Friendly ID
  extend FriendlyId
  friendly_id :name, use: :slugged

  def slug_path
    concat_slug = slug
    current_parent = parent
    while current_parent.instance_of? Folder
      concat_slug.prepend "#{current_parent.slug}/"
      current_parent = current_parent.parent
    end
    concat_slug
  end

end
