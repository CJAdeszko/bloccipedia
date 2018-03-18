class CollaboratorsController < ApplicationController
  def new
    @collaborator = Collaborator.new
  end

  def create
    @wiki = Wiki.find(params[:wiki_id])
    @user = User.find_by_email(params[:search])

    if @user
      @collaborator = Collaborator.new(wiki_id: @wiki.id, user_id: @user.id)
      if @collaborator.save
        flash[:notice] = "Collaborator successfully added to #{@wiki.title}."
      else
        flash[:alert] = "There was a problem adding the collaborator. Please try again."
        redirect_to @wiki
      end
    else
      flash[:alert] = "Invalid email address for collaborator. Please try again"
    end
    redirect_to @wiki
  end

  def destroy
    @wiki = Wiki.find(params[:wiki_id])
    @collaborator = Collaborator.find(params[:id])
    @user = User.find(@collaborator.user_id)

    if @collaborator.destroy
      flash[:notice] = "#{@user.email} was removed from the Wiki"
      redirect_to @wiki
    else
      flash.now[:alert] = "There was an error removing the collaborator"
      redirect_to @wiki
    end
  end
end
