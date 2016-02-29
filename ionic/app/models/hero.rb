class Hero < ActiveRecord::Base
  belongs_to :photo
  belongs_to :item, polymorphic: true
end
