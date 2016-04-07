class ImagesController < ApplicationController

  def destroy
    @image = Image.find_by(imageable_id: params[:imageable_id])
    @image.delete
    redirect_to edit_gig_path(params[:gig])
  end

end