# app/controllers/attendances_controller.rb
class AttendancesController < ApplicationController
  before_action :set_attendance, only: [:show, :edit, :update, :destroy]

  def index
    @attendance = Attendance.order(time_arrived: :desc)
  end

  def new
    @attendance = Attendance.new
  end

  def edit
  end

  def create
    @attendance = Attendance.new(attendance_params)

    @attendance.member_id = nil
    @attendance.event_id = nil
    @attendance.time_arrived = Time.current.in_time_zone('Central Time (US & Canada)')
    @attendance.time_departed = Time.current.in_time_zone('Central Time (US & Canada)')

  end

  def update
    @attendance = Attendance.find(params[:id])
    if @attendance.update(attendance_update_params)
      flash[:notice] = "Attendance successfully updated"
      redirect_to attendance_path
    else
      flash[:notice] = "Attendance update failed"
      redirect_to edit_attendance_path(@attendance)
    end
  end

  def destroy
    @attendance.destroy
    flash[:notice] = "Attendance successfully destoyed"
    redirect_to attendance_path
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
