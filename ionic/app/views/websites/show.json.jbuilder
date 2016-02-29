json.(@website, :id, :slug, :name, :created_at, :updated_at)
json.collections @website.collections do |collection|
  json.(collection, :id, :slug, :name, :created_at, :updated_at)
  json.hero_photo do
    json.url collection.hero_photo.tcb_photo_url
  end if collection.hero_photo
end

