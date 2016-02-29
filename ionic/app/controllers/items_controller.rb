class ItemsController < ApplicationController

  before_action :load_item, only: [:show]

  def index
    @collection = Collection.friendly.find(params[:id])
    @items = @collection.items
    authorize! :read, Item if @items.empty?
    @items.each do |item|
      authorize! :read, item
    end
    render json: @items, include: [:photos]
  end

  def show
    authorize! :read, @item
    respond_to do |format|
      format.html
      format.json { render } #{
        # render json: @website,
        #        include: [collections: {
        #                      include: [hero_photo: {only: [:id, :tcb_photo_url]} ]
        #                      # include: [{ folders: { include: [ { items: { include: [:photos] } } ] } },
        #                      #           { items: { include: [:photos] } }]
        #                  } ]
      #}
    end
  end

  def upload_avatar
    authorize! :update, @collection
  end

  def update
    authorize! :update, @item
    @item.update_attributes(item_params)
    redirect_to item_path(@item)
  end

  private

  def load_item
    @collection = Collection.friendly.find(params[:collection_id]) if params[:collection_id]
    path = item_params[:id].split('/')
    puts "Path: #{path}"
    @item = @collection ? @collection.items.where(slug: path.last) : Item.friendly.find(path.last)
  end

  def item_params
    params.permit(:id)
  end
end
