class Photo < ActiveRecord::Base

  belongs_to :item
  has_many :heros

  def tcb_photo_url
    #endpoint = 'http://localhost:9000'
    endpoint = 'http://www.thecollectingbug.com/tor-photos'
    "#{endpoint}/cards/#{item.collection.slug}/#{item.slug}/p_#{photo_num}_thu.jpg"
  end
end
