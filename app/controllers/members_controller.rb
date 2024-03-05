class MembersController < ApplicationController

  before_action :require_admin, except: [:index, :show, :destroy, :edit, :update]   # See 'require_admin' in 'app/controllers/application_controller.rb'
  before_action :authorize_member_or_admin, only: [:show, :edit, :update]   # See 'authorize_member_or_admin' under private functions
  before_action :index_authorize, only: [:index]

  def index
    @members = Member.order(email: :asc)
  end

  def show
    @member = Member.find(params[:id])
  end

  def new
    @member = Member.new(email: params[:email])
  end

  def create
    @member = Member.new(member_params)
    @member.date_joined = Date.today

    if @member.email == nil
      redirect_to new_member_path(email: @member.email)
    end

    existing_member = Member.find_by(email: @member.email)

    if existing_member 
      flash[:alert] = "Member with this email already exists."
      redirect_to new_member_path(email: @member.email)
    elsif @member.save
      flash[:success] = "Sign Up successful. Welcome to Bhakti Yoga Club!"
      redirect_to root_path
    else
      flash[:alert] = "Invalid Email"
      redirect_to new_member_path(email: @member.email)
    end
  end

  def edit
    @member = Member.find(params[:id])
  end

  def update
    @member = Member.find(params[:id])
    if @member.update(member_update_params)
      flash[:success] = "Member successfully updated"
      redirect_to member_path(@member)
    else
      flash[:alert] = "Member update failed"
      redirect_to edit_member_path(@member)
    end
  end

  def delete
    @member = Member.find(params[:id])
  end

  def destroy
    if current_member
      if current_member.is_admin?
        if (params[:id] != "sign_out")
          @member = Member.find(params[:id])
          if @member != current_member
            @member.destroy
            flash[:notice] = "Member deleted"
          else
            flash[:notice] = "You cannot delete yourself."
          end
        else
          sign_out current_member
          flash[:notice] = "You have been signed out"
        end
      else
        sign_out current_member
        flash[:notice] = "You have been signed out"
      end
    else
      flash[:alert] = "You are not signed in."
    end
    redirect_to root_path
  end

  # def destroy
  #   if current_member
  #     sign_out current_member
  #     flash[:notice] = "You have been signed out."
  #   else
  #     flash[:alert] = "You are not signed in"
  #   end
  #   redirect_to root_path
  # end

  private

  def member_params
    params.require(:member).permit(:email)
  end

  def member_update_params
    params.require(:member).permit(
      :email,
      :title,
      :is_active_paid_member,
      :is_admin,
      :is_on_mailing_list
      )
  end

  # Function that determines whether a user should be able to view their personal member data. (Access only to admins and that member)
  def authorize_member_or_admin
    @member = Member.find(params[:id])
    unless current_member == @member || current_member&.is_admin?
      flash[:alert] = "You are not authorized to access this page."
      redirect_to root_path
    end
  end

  def index_authorize
    unless member_signed_in?
      flash[:alert] = "You are not authorized to access this page."
      redirect_to root_path
    end
  end
end
