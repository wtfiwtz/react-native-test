class WebsitesController < ApplicationController

  before_action :load_website, only: [:show]

  def show
    authorize! :read, @website
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
    authorize! :update, @website
  end

  def update
    authorize! :update, @website
    @website.update_attributes(website_params)
    redirect_to website_path(@website)
  end

  private

  def load_website
    @website = Website.friendly.find(params[:id])
  end

  def website_params
    params.require(:website).permit(:image)
  end
end
