json.(@item, :id, :title, :item_type, :item_id, :created_at, :updated_at)
json.photos @item.photos do |photo|
  json.(photo, :id)
  json.url photo.tcb_photo_url
end


