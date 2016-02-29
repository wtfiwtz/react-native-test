require 'active_support/concern'
require 'net/http'
require 'uri'
require 'json'

module TcbImport
  extend ActiveSupport::Concern

  attr_accessor :collections, :folders, :items, :photos

  def word
    'DORDSSAP'.reverse
  end

  def init
    @server = 'localhost:8081'
    @base_url = '/api/v1'
    @folders = {}
    @items = {}
    @photos = {}
  end

  def import
    # Login
    @token = login('USER', word)

    # Remove everything!
    clean!

    # Get collections and items
    @collections = get_collections
    collections = collection_ids
    collections.each do |collection_id|
      get_folders(collection_id)
      folders = folder_ids(collection_id)
      folders.each do |folder_id|
        get_items(collection_id, folder_id)
      end
    end

    persist
    logout
  end

  def login(username, password)
    result = Net::HTTP.post_form(URI("http://#{@server}#{@base_url}/sessions"), {username: username, password: password})
    JSON.parse(result.body)['sessionId']
  end

  def logout
    uri = URI("http://#{@server}#{@base_url}/sessions/#{@token}")
    delete = Net::HTTP::Delete.new(uri)
    res = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(delete)
    end
    @token = nil
  end

  def get_collections
    uri = URI("http://#{@server}#{@base_url}/collections")
    get = Net::HTTP::Get.new(uri)
    get['Cookie'] = "sessionId=#{@token}"
    res = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(get)
    end
    @collections = JSON.parse(res.body)
  end

  def get_folders(collection_id)
    puts "Get folders: #{collection_id}"
    uri = URI("http://#{@server}#{@base_url}/folders/#{collection_id}")
    get = Net::HTTP::Get.new(uri)
    get['Cookie'] = "sessionId=#{@token}"
    res = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(get)
    end
    @folders[collection_id] = JSON.parse(res.body)
  end

  def get_items(collection_id, folder_id)
    puts "Get items: #{collection_id}/#{folder_id}"
    uri = URI("http://#{@server}#{@base_url}/objects/#{collection_id}~#{folder_id}")
    get = Net::HTTP::Get.new(uri)
    get['Cookie'] = "sessionId=#{@token}"
    res = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(get)
    end
    @items["#{collection_id}/#{folder_id}"] = JSON.parse(res.body)
  end

  def get_photos(collection_id, folder_id, item_id)
    #puts "Get photos: #{collection_id}/#{folder_id}/#{item_id}"
    translated_folder_id = folder_id.tr('/', '~')
    uri = URI("http://#{@server}#{@base_url}/resources/#{collection_id}~#{translated_folder_id}~#{item_id}")
    get = Net::HTTP::Get.new(uri)
    get['Cookie'] = "sessionId=#{@token}"
    res = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(get)
    end

    begin
      json = JSON.parse(res.body)
      @photos["#{collection_id}/#{folder_id}/#{item_id}"] = json unless json.empty?
    rescue JSON::ParserError => pe
      puts "Parser error: #{collection_id}/#{folder_id}/#{item_id}"
    end
  end

  def persist
    # Handle the collections
    website_id = @collections.first['deckId']['tudi']
    website = Website.create!(slug: website_id, name: website_id)
    @collections.each do |collection|
      collection_id = collection['deckId']['tudi']
      c = Collection.create!(slug: collection_id, name: collection['deckId']['assignedId'], website: website)

      # Handle the folders
      @folders[collection_id].each do |folder|
        folder_id = folder['folderId']['tufi']
        f = Folder.create!(slug: folder_id, name: folder['folderId']['name'], collection: c, parent: c)

        # Handle the items
        @items["#{collection_id}/#{folder_id}"].each do |item|
          item_id = item['itemId']['tuci']

          parent_ids = []

          parent = item['itemId']['parent']
          while parent['tufi']
            parent_ids.prepend(parent['tufi'])
            parent = parent['parent']
          end

          f = nil
          p = c
          while not parent_ids.empty?
            id = parent_ids.shift
            f = Folder.where(parent: p, slug: id).first_or_create!(name: id, collection: c)
            p = f
          end

          i = Item.create!(slug: item_id, item_id: item['itemId']['assignedId'], title: item['objectTitle'], item_type: item['objectType'], collection: c, folder: f)
        end
      end
    end
  end


  def photos_for_items
    @token = login('philip', word)

    Item.all.each do |item|
      get_photos(item.collection.slug, item.folder.slug_path, item.slug)

      @photos.each do |item_path, photoset|
        photoset.each do |photo|
          #puts "Import photo: #{photo.inspect}"
          Photo.create!(photo_num: photo['photoId']['photoNum']['value'], filename: photo['uploadFilename'], available: photo['fileAvailable'], sort_order: photo['sortOrder'],
                        original_height: photo['originalHeightPixels'], original_width: photo['originalWidthPixels'], item: item)
        end
      end
      @photos.clear
    end

    logout
  end

  def clean!
    Photo.delete_all
    Item.delete_all
    Folder.delete_all
    Collection.delete_all
  end


  def collection_ids
    @collections.map{|x| x['deckId']['tudi'] }
  end

  def first_field_id
    @collections[0]['spotDescriptorList'][0]['spotId']['tusi']
  end

  def folder_ids(collection_id)
    @folders[collection_id].collect { |x| x['folderId']['tufi'] }
  end

  # ["deckId", "path", "deckName", "description", "cardCount", "folderCount", "visibility", "visibilityChangeDate",
  # "votes", "rating", "gallerySize", "itemsTrading", "itemsWanted", "itemsForSale", "totalItems", "photos", "comments",
  # "tags", "publicFieldNames", "privateFieldNames", "individualRatings", "spotVariationSummary", "spotDescriptorList",
  # "curators", "privateViewers", "customCSS", "backgroundStyles", "bannerColourStyles", "persisted", "objectIdList", "last50Objects"]

  def collection_fields
    @collections[0]['spotDescriptorList']
  end

end

%w[
  class Test
    include TcbImport
  end
  t=Test.new
  t.init
  r=t.import
  r2=t.photos_for_items
%]