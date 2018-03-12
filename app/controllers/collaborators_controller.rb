class CollaboratorsController < ApplicationController
  def new
    @collaborator = Collaborator.new
  end

  def create
    @wiki = Wiki.find(params[:wiki_id])
    @user = User.where("email LIKE ? ", "%#{params[:search]}%")
    @collaborator = Collaborator.new(wiki: @wiki, user: @user)

    if @collaborator.save
      flash[:notice] = "Collaborator successfully added to #{@wiki.title}."
    else
      flash[:error] = "There was a problem adding the collaborator. Please try again."
    end
  end

  def destroy
    @wiki = Wiki.find(params[:wiki_id])
    @collaborator = Collaborator.find(params[:id])

    if @collaborator.destroy
      flash[:notice] = "#{@collaborator.email} was removed from the Wiki"
      redirect_to @wiki
    else
      flash.now[:alert] = "There was an error removing the collaborator"
      render :edit_wiki_path
    end
  end
end
