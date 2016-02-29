class CollectionsController < ApplicationController

  before_action :load_collection, only: [:show]

  def index
    @collections = Collection.all
    authorize! :read, Collection if @collections.empty?
    @collections.each do |collection|
      authorize! :read, collection
    end
    render json: @collections
  end

  def show
    authorize! :read, @collection
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
    authorize! :update, @collection
    @collection.update_attributes(collection_params)
    redirect_to collection_path(@collection)
  end

  private

  def load_collection
    @collection = Collection.friendly.find(params[:id])
  end

  def collection_params
    params.require(:collection).permit(:image)
  end
end
