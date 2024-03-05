require 'rails_helper'

RSpec.describe AttendancesController, type: :controller do

  let(:event) { Event.create!(
    name: "Sample Event",
    start_time: DateTime.now,
    end_time: DateTime.now + 1.hour, 
    location: 'Sample Location'
    ) 
  }

  let(:member) {
    Member.create(
      email: 'hld7dp@tamu.edu',
      full_name: 'Steven Luo',
      title: 'DefaultMember',
      is_active_paid_member: false,
      is_admin: true,
      date_joined: '2024-02-12',
      created_at: '2024-02-12 20:02:30.814754',
      updated_at: '2024-02-12 20:02:30.814754',
      is_on_mailing_list: true
    )
  }



  let(:valid_attributes) do
    {
      member_id: member.id, 
      event_id: event.id,  
      time_arrived: Time.now,
      time_departed: Time.now + 1.hour
    }
  end

  let(:invalid_attributes) do
    {
      member_id: nil,
      event_id: nil,
      time_arrived: nil,
      time_departed: nil
    }
  end

  describe "GET #index" do
    it "returns a successful response" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "assigns all attendances as @attendances" do
      attendance = Attendance.create!(valid_attributes)
      get :index
      expect(assigns(:attendance)).to eq([attendance])
    end
  end

  describe "GET #new" do
    it "returns a successful response" do
      get :new
      expect(response).to have_http_status(:success)
    end

    it "assigns a new attendance as @attendance" do
      get :new
      expect(assigns(:attendance)).to be_a_new(Attendance)
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "creates a new attendance" do
        expect {
          post :create, params: { attendance: valid_attributes }
        }.to change(Attendance, :count).by(1)
      end

      it "redirects to the attendances_path" do
        post :create, params: { attendance: valid_attributes }
        expect(response).to redirect_to(attendances_path)
      end
    end

    context "with invalid attributes" do
      it "does not create a new attendance" do
        expect {
          post :create, params: { attendance: invalid_attributes }
        }.not_to change(Attendance, :count)
      end

      it "renders the new template with flash error message" do
        post :create, params: { attendance: invalid_attributes }
        expect(response).to render_template(:new)
        expect(flash[:error]).not_to be_nil
      end
    end
  end

  describe "GET #edit" do
    let(:attendance) { Attendance.create!(valid_attributes) }

    it "returns a successful response" do
      get :edit, params: { id: attendance.id }
      expect(response).to have_http_status(:success)
    end

    it "assigns the requested attendance as @attendance" do
      get :edit, params: { id: attendance.id }
      expect(assigns(:attendance)).to eq(attendance)
    end
  end

  describe "PUT #update" do
    let(:attendance) { Attendance.create!(valid_attributes) }

    context "with valid attributes" do
      it "updates the requested attendance" do
        put :update, params: { id: attendance.id, attendance: { time_arrived: Time.now + 2.hours } }
        attendance.reload
        expect(attendance.time_arrived).to be_within(1.second).of(Time.now + 2.hours)
      end

      it "redirects to the attendance_path" do
        put :update, params: { id: attendance.id, attendance: valid_attributes }
        expect(response).to redirect_to(attendance_path)
      end
    end

    context "with invalid attributes" do
      it "does not update the requested attendance" do
        put :update, params: { id: attendance.id, attendance: invalid_attributes }
        attendance.reload
        expect(attendance.time_arrived).not_to be_nil
      end

      it "renders the edit template with flash error message" do
        put :update, params: { id: attendance.id, attendance: invalid_attributes }
        expect(response).to render_template(:edit)
        expect(flash[:error]).not_to be_nil
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:attendance) { Attendance.create!(valid_attributes) }

    it "destroys the requested attendance" do
      expect {
        delete :destroy, params: { id: attendance.id }
      }.to change(Attendance, :count).by(-1)
    end

    it "redirects to the attendances_path" do
      delete :destroy, params: { id: attendance.id }
      expect(response).to redirect_to(attendances_path)
    end
  end
end
