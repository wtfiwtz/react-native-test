class FoldersController < ApplicationController

  before_action :load_folder, only: [:show]

  def index
    @folders = Collection.friendly.find(params[:id]).folders
    authorize! :read, Folder unless @folders
    @folders.each do |folder|
      authorize! :read, folder
    end
    render json: @folders
  end

  def show
    authorize! :read, @folder
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
    authorize! :update, @folder
  end

  def update
    authorize! :update, @folder
    @folder.update_attributes(folder_params)
    redirect_to folder_path(@folder)
  end

  private

  def load_folder
    @collection = Collection.friendly.find(params[:collection_id]) if params[:collection_id]
    path = folder_params[:id].split('/')
    puts "Path: #{path}"
    @folder = @collection ? @collection.folders.where(slug: path.last) : Folder.friendly.find(path.last)
  end

  def folder_params
    params.permit(:id)
  end
end
