class MembersController < ApplicationController
  def index
    @members = Member.order(email: :desc)
  end

  def show
    @member = Member.find(params[:id])
  end

  def new
    @member = Member.new
  end

  def create
    @member = Member.new(member_params)
    @member.date_joined = Date.today

    if @member.save
      redirect_to root_path, notice: "Sign Up successful. Welcome to Bhakti Yoga Club!"
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
