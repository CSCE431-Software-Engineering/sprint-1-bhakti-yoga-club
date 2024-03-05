# app/controllers/concerns_controller.rb
class ConcernsController < ApplicationController
  before_action :authenticate_member!
  before_action :set_member, only: [:index]
  before_action :set_concerns, only: [:index, :sort_by_title, :sort_by_time, :sort_by_status]


  def index
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
      flash[:error] = "Failed to update concern"
      render 'edit'
    end
  end
  

  def sort_by_title
    @concerns = @concerns.order(title: :asc)
    render_js_partial
  end
  
  def sort_by_time
    @concerns = @concerns.order(updated_at: :desc)
  
    render_js_partial
  end
  
  def sort_by_status
    custom_status_order = ['in_progress', 'read', 'unread', 'resolved']
    @concerns = @concerns.sort_by { |concern| custom_status_order.index(concern.status) }
  
    render_js_partial
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

  def set_concerns
    if current_member.is_admin?
      @concerns = Concern.all
    else
      @concerns = current_member.concerns
    end
  end
  
  

  def concern_params
    params.require(:concern).permit(:title, :description, :status)
  end

  def set_member
    @member = current_member
  end

  def set_concern
    @concern = @member.concerns.find(params[:id])
  end

  def render_js_partial
    respond_to do |format|
      format.html { render partial: 'concerns/index', locals: { concerns: @concerns } }
      format.js   # This will render a .js.erb file with the same name as the action (e.g., sort_by_title.js.erb)
    end
  end
end
