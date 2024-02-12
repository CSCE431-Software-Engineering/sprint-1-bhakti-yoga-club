class MembersController < ApplicationController
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

    existing_member = Member.find_by(email: @member.email)

    if existing_member 
      flash[:notice] = "Member with this email already exists."
      redirect_to new_member_path(email: @member.email)
    elsif @member.save
      flash[:notice] = "Sign Up successful. Welcome to Bhakti Yoga Club!"
      redirect_to root_path
    else
      flash[:notice] = "Invalid Email"
      redirect_to new_member_path(email: @member.email)
    end
  end

  def edit
    @member = Member.find(params[:id])
  end

  def update
    @member = Member.find(params[:id])
    if @member.update(member_update_params)
      flash[:notice] = "Member successfully updated"
      redirect_to members_path
    else
      render :edit
    end
  end

  def delete
    @member = Member.find(params[:id])
  end

  def destroy
    @member = Member.find(params[:id])
    if @member.destroy
      flash[:notice] = "Member deleted successfully"
    else
      flash[:notice] = "Member could not be deleted"
    end
    redirect_to members_path
  end

  def member_params
    params.require(:member).permit(:email)
  end

end
