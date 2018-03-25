class CollaboratorsController < ApplicationController
  def new
    @collaborator = Collaborator.new
  end

  def create
    @wiki = Wiki.find(params[:wiki_id])
    @user = User.find_by_email(params[:search])

    if @user
      if @user.id == current_user.id
        flash[:alert] = "Cannot add current user as a collaborator"
      elsif @wiki.collaborators.exists?(user_id: @user.id)
        flash[:alert] = "User is already a collaborator on this wiki"
      else
        @collaborator = Collaborator.new(wiki_id: @wiki.id, user_id: @user.id)
        if @collaborator.save
          flash[:notice] = "Collaborator successfully added to #{@wiki.title}."
        else
          flash[:alert] = "There was a problem adding the collaborator. Please try again."
        end
      end
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
