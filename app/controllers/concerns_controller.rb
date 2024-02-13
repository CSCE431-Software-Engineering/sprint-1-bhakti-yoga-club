# app/controllers/concerns_controller.rb
class ConcernsController < ApplicationController
  before_action :authenticate_member!
  before_action :set_member, only: [:index] # Add this line

  def index
    @concerns = @member.concerns
  end

  def new
    @concern = Concern.new
  end

  def destroy
    @concern = Concern.find(params[:id]) # Find the concern by its ID
    @concern.destroy
    respond_to do |format|
      format.html { redirect_to member_concerns_url(current_member), notice: 'Concern was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def edit
    @concern = Concern.find(params[:id])
  end

  def update
    @concern = Concern.find(params[:id])
    if @concern.update(concern_params)
      flash[:success] = "Concern updated successfully!"
      redirect_to member_concerns_path(current_member)
    else
      render 'edit'
    end
  end
  
  

  def create
    @concern = current_member.concerns.build(concern_params)

    if @concern.save
      flash[:success] = "Concern submitted successfully!"
      redirect_to member_concerns_path(current_member)
    else
      render 'new'
    end
  end
  
  private

  def concern_params
    params.require(:concern).permit(:title, :description)
  end

  def set_member
    @member = current_member
  end

  def set_concern
    @concern = @member.concerns.find(params[:id])
  end
end
