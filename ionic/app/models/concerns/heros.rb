require 'active_support/concern'

module Heros
  extend ActiveSupport::Concern

  def pick_hero!
    return if hero
    item = items.joins(:photos).where('photos.id IS NOT NULL').first
    return unless item
    photo = item.photos.first
    create_hero!(photo: photo)
  end

  module ClassMethods

    def reset_all_heros!
      Hero.destroy_all
    end

    def pick_all_heros!
      self.joins("LEFT OUTER JOIN heros ON #{table_name}.id = heros.item_id AND '#{self.to_s}' = heros.item_type").where('heros.item_id IS NULL').each do |item|
        item.pick_hero!
      end
    end
  end
end


