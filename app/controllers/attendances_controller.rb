# app/controllers/attendances_controller.rb
class AttendancesController < ApplicationController
  before_action :set_attendance, only: [:show, :edit, :update, :destroy]

  def index
    @attendance = Attendance.order(created_at: :desc)
    @events = Event.all
  end

  def new
    @attendance = Attendance.new
  end

  def edit
  end

  def create
    @attendance = Attendance.new(attendance_params)

    @attendance.member_id = current_member.id

    respond_to do |format|
      if @attendance.save
        format.html { redirect_to attendances_path, notice: 'Attendance Item created successfully!'}
      else
        Rails.logger.debug @attendance.errors.full_messages.join(', ')
        format.html { render :new, status: :unprocessable_entity, flash: { error: @attendance.errors.full_messages.join(', ') } }
      end
    end

  end

  def update
    @attendance = Attendance.find(params[:id])
    if @attendance.update(attendance_params)
      flash[:notice] = "Attendance successfully updated"
      redirect_to attendance_path
    else
      flash[:notice] = "Attendance update failed"
      redirect_to edit_attendance_path(@attendance)
    end
  end

  def destroy
    @attendance.destroy
    flash[:notice] = "Attendance successfully destroyed"
    redirect_to attendances_path
  end

  private
  def set_attendance
    return unless params[:id]
    @attendance = Attendance.find(params[:id])
  end

  def attendance_params
    params.require(:attendance).permit(:member_id, :event_id, :time_arrived, :time_departed)
  end

end
