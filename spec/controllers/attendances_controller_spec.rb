# spec/controllers/attendances_controller_spec.rb
require 'rails_helper'

RSpec.describe AttendancesController, type: :controller do
  describe '#set_attendance' do
    controller do
      before_action :set_attendance, only: [:show, :edit, :update, :destroy]
    end

    context 'when params[:id] is present' do
      it 'assigns the correct attendance' do

        member = Member.create(
          email: 'john.doe@example.com',
          title: 'Mr.',
          is_active_paid_member: true,
          is_admin: false,
          date_joined: Date.today,
          date_left: nil 
        )


        event = Event.create(
          name: 'Test event',
          created_at: Time.current,
          updated_at: Time.current
        )


        # Create an example attendance in the database
        attendance = Attendance.create(
          member_id: member.id, 
          event_id: event.id, 
          time_arrived: Time.current, 
          time_departed: Time.current
        )

        # Manually set the params to include the correct attendance id
        controller.params[:id] = attendance.id

        # Call the set_attendance method directly
        controller.send(:set_attendance)

        # Expect that the @attendance instance variable is assigned correctly
        expect(assigns(:attendance)).to eq(attendance)
      end
    end

    context 'when params[:id] is not present' do
      it 'does not raise ActiveRecord::RecordNotFound' do
        # Call the set_attendance method directly without setting params[:id]
        expect { controller.send(:set_attendance) }.not_to raise_error
      end

      it 'does not assign @attendance' do
        # Call the set_attendance method directly without setting params[:id]
        controller.send(:set_attendance)

        # Expect that @attendance is not assigned
        expect(assigns(:attendance)).to be_nil
      end
    end
  end


  describe '#attendance_params' do
    let(:current_time) { Time.current }

    let(:valid_params) do
      {
        attendance: {
          member_id: 1,
          event_id: 1,
          time_arrived: current_time, 
          time_departed: current_time
        }
      }
    end

    it 'permits valid parameters' do
      controller.params = valid_params
      expect(controller.send(:attendance_params).to_h).to eq(
        'member_id' => 1,
        'event_id' => 1,
        'time_arrived' => current_time,
        'time_departed' => current_time
      )
    end
  end

  describe 'DELETE #destroy' do

    member = Member.create(
      email: 'john.doe@example.com',
      title: 'Mr.',
      is_active_paid_member: true,
      is_admin: false,
      date_joined: Date.today,
      date_left: nil 
    )

    event = Event.create(
      name: 'Test event',
      created_at: Time.current,
      updated_at: Time.current
    )

    attendance = Attendance.create(
      member_id: member.id, 
      event_id: event.id, 
      time_arrived: Time.current, 
      time_departed: Time.current
    )

    it 'destroys the attendance' do
      expect {
        delete :destroy, params: { id: attendance.id }
      }.to change(Attendance, :count).by(-1)

      expect(response).to redirect_to(attendances_url)
      expect(flash[:notice]).to eq('Attendance Item was successfully destroyed.')
    end


  end

  describe 'PATCH #update' do

    member = Member.create(
      email: 'john.doe@example.com',
      title: 'Mr.',
      is_active_paid_member: true,
      is_admin: false,
      date_joined: Date.today,
      date_left: nil 
    )

    event = Event.create(
      name: 'Test event',
      created_at: Time.current,
      updated_at: Time.current
    )

    attendance = Attendance.create(
      member_id: member.id, 
      event_id: event.id, 
      time_arrived: Time.current, 
      time_departed: Time.current
    )

    context 'with valid parameters' do
      let(:valid_params) do
        {
          attendance: {
            member_id: member.id, 
            event_id: event.id, 
            time_arrived: Time.current, 
            time_departed: nil
          }
        }
      end

      it 'updates the attendance' do
        patch :update, params: { id: attendance.id, attendance: valid_params[:attendance] }

        expect(response).to redirect_to(attendances_path)
        expect(flash[:notice]).to eq('Attendence updated successfully!')
      end

    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        {
          attendance: {
            member_id: nil, # invalid member id
            event_id: event.id
            time_arrived: Time.current,
            time_departed: Time.current
          }
        }
      end

      it 'does not update the attendance' do
        patch :update, params: { id: attendance.id, attendance: invalid_params[:attendance] }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:edit)
      end


    end
  end


  describe 'POST #create' do

    context 'with valid parameters' do

      it 'creates a new attendance' do
        membersa = Member.create(
          email: 'john.doe@example.com',
          title: 'Mr.',
          is_active_paid_member: true,
          is_admin: false,
          date_joined: Date.today,
          date_left: nil 
        )

        eventa = Event.create(
          name: 'Test event 2',
          created_at: Time.current,
          updated_at: Time.current
        )

        attendance_params = {
          member_id: membersa.id,
          event_id: eventa.id,
          time_arrived: Time.current,
          time_departed: Time.current
        }


        expect do
          post :create, params: { attendance: attendance_params }
        end.to change(Attendance, :count).by(1)

        expect(response).to redirect_to(attendances_path)
        expect(flash[:notice]).to eq('Attendance Item created successfully!')

      end
    end

    context 'with invalid parameters' do
      member = Member.create(
        email: 'john.doe@example.com',
        title: 'Mr.',
        is_active_paid_member: true,
        is_admin: false,
        date_joined: Date.today,
        date_left: nil 
      )

      event = Event.create(
        name: 'Test event',
        created_at: Time.current,
        updated_at: Time.current
      )

      let(:invalid_params) do
        {
          attendance: {
            member_id: member.id,
            event_id: nil, #invalid event id
            time_arrived: Time.current,
            time_departed: Time.current
          }
        }
      end

      it 'does not create a new attendance' do
        expect {
          post :create, params: invalid_params
        }.not_to change(Attendance, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end

    end
  end  
end