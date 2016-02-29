json.(@folder, :id, :slug, :name, :description, :created_at, :updated_at)
json.hero_photo do
  json.url @folder.hero_photo.tcb_photo_url
end if @folder.hero_photo
json.items @folder.items do |item|
  json.(item, :id, :title, :item_type, :item_id, :created_at, :updated_at)
  json.path "#{item.collection.slug}/#{item.folder.slug_path}/#{item.slug}"
  json.photos item.photos do |photo|
    json.(photo, :id)
    json.url photo.tcb_photo_url
  end
end
json.folders @folder.folders do |folder|
  json.(folder, :id, :slug, :name, :description)
  json.hero_photo do
    json.url folder.hero_photo.tcb_photo_url
  end if folder.hero_photo
end
