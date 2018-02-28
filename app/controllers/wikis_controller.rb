class WikisController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show, :index]


  def index
    if current_user.nil? || current_user.standard?
      @wikis = Wiki.where( private: false )
    elsif current_user.premium?
      @wikis = Wiki.where( "user_id = ? OR private = ?", current_user.id, false)
    else
      @wikis = Wiki.all
    end
  end


  def new
    @wiki = Wiki.new
  end


  def create
    @wiki = Wiki.new(wiki_params)
    @wiki.user = current_user
    @wiki.private ||= false

    if @wiki.save
      flash[:notice] = "Wiki was saved."
      redirect_to [@wiki]
    else
      flash.now[:alert] = "There was an error saving the Wiki. Please try again."
      render :new
    end
  end


  def show
    @wiki = Wiki.find(params[:id])
  end


  def edit
    @wiki = Wiki.find(params[:id])
  end


  def update
    @wiki = Wiki.find(params[:id])
    @wiki.assign_attributes(wiki_params)

    if @wiki.save
      flash[:notice] = "Wiki was updated."
      redirect_to [@wiki]
    else
      flash.now[:alert] = "There was an error saving the Wiki. Please try again."
      render :edit
    end
  end


  def destroy
    @wiki = Wiki.find(params[:id])

    if @wiki.destroy
      flash[:notice] = "#{@wiki.title} was deleted successfully."
      redirect_to action: :index
    else
      flash.now[:alert] = "There was an error deleting the Wiki. Please try again."
      render :show
    end
  end


  private

  def wiki_params
    params.require(:wiki).permit(:title, :body, :private)
  end

end
