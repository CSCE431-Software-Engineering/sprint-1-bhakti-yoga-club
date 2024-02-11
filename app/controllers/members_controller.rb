class MembersController < ApplicationController
  def index
    @members = Member.order(email: :desc)
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
      render :new
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def member_params
    params.require(:member).permit(:email)
  end

end
