# spec/controllers/announcements_controller_spec.rb
require 'rails_helper'

RSpec.describe AnnouncementsController, type: :controller do
  let(:valid_params) { { message_title: 'New Announcement', message_text: 'Exciting News' } }

  member = Member.find_by(id: 1)

  if member.nil?
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
  end

  announcement = Announcement.find_by(id: 1)

  if announcement.nil?
    announcement = Announcement.create(
      message_title: 'Test Title', 
      message_text: 'Test Text', 
      message_date: Time.current, 
      member_id: 1
    )
  end

  describe '#set_announcement' do
    controller do
      before_action :set_announcement, only: [:show, :edit, :update, :destroy]
    end

    context 'when params[:id] is present' do
      it 'assigns the correct announcement' do
        
        # Create an example announcement in the database
        announcement = Announcement.create(
          message_title: 'Test Title', 
          message_text: 'Test Text', 
          message_date: Time.current, 
          member_id: 1
        )

        # Manually set the params to include the correct announcement id
        controller.params[:id] = announcement.id

        # Call the set_announcement method directly
        controller.send(:set_announcement)

        # Expect that the @announcement instance variable is assigned correctly
        expect(assigns(:announcement)).to eq(announcement)
      end
    end

    context 'when params[:id] is not present' do
      it 'does not raise ActiveRecord::RecordNotFound' do
        # Call the set_announcement method directly without setting params[:id]
        expect { controller.send(:set_announcement) }.not_to raise_error
      end

      it 'does not assign @announcement' do
        # Call the set_announcement method directly without setting params[:id]
        controller.send(:set_announcement)

        # Expect that @announcement is not assigned
        expect(assigns(:announcement)).to be_nil
      end
    end
  end


  describe '#announcement_params' do
    let(:current_time) { Time.current }

    let(:valid_params) do
      {
        announcement: {
          message_title: 'Test Title',
          message_text: 'Test Text',
          message_date: current_time,
          member_id: 1
        }
      }
    end

    it 'permits valid parameters' do
      controller.params = valid_params
      expect(controller.send(:announcement_params).to_h).to eq(
        'message_title' => 'Test Title',
        'message_text' => 'Test Text',
        'message_date' => current_time,
        'member_id' => 1
      )
    end
  end

  describe '#index' do
    it 'assigns announcements in descending order of message_date' do
      # Create a single announcement with a unique message_date
      announcement = Announcement.create(
        message_title: 'Test Title', 
        message_text: 'Test Text', 
        message_date: Time.current, 
        member_id: 1
      )

      # Call the index method
      get :index

      # Access the ID directly from the single announcement
      assigned_id = assigns(:announcements).first.id

      # Expect that the @announcements instance variable is assigned
      # Check only for the order, using the valid ID
      expect(assigned_id).to eq(announcement.id)
    end
  end

  describe 'GET #new' do
    context 'when a member is signed in' do
      before do
        sign_in member
        get :new
      end

      it 'assigns a new Announcement to @announcement' do
        expect(assigns(:announcement)).to be_a_new(Announcement)
      end

      it 'renders the new template' do
        expect(response).to render_template :new
      end
    end
  end


  describe '#destroy' do
    before do
      sign_in member
    end
      
    it 'destroys the announcement' do
      announcement = Announcement.create(
        message_title: 'Test Title', 
        message_text: 'Test Text', 
        message_date: Time.current, 
        member_id: 1
      )

      expect{
        delete :destroy, params: { id: announcement.id }
      }.to change(Announcement, :count).by(-1)
    end
  end

  describe 'PATCH #update' do
    context 'when a member is signed in' do
      before do
        sign_in member
      end

      context 'with valid params' do
        let(:valid_params) { { message_title: 'New Title', message_text: 'New Text' } }

        it 'updates the requested announcement' do
          patch :update, params: { id: 1, announcement: valid_params }
          announcement = Announcement.find_by(id: 1)
          expect(announcement.message_title).to eq('New Title')
          expect(announcement.message_text).to eq('New Text')
        end

        it 'redirects to announcements_path with a notice' do
          patch :update, params: { id: 1, announcement: valid_params }
          expect(response).to redirect_to(announcements_path)
          expect(flash[:notice]).to eq('Announcement updated successfully!')
        end
      end

      context 'with invalid params' do
        let(:invalid_params) { { message_title: '', message_text: '' } }

        it 'renders the edit template with unprocessable_entity status' do
          patch :update, params: { id: 1, announcement: invalid_params }
          expect(response).to render_template :edit
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

    end
  end

  describe 'POST #create' do
    context 'when a member is signed in' do
      before do
        sign_in member
      end

      context 'with valid params' do
        it 'creates a new announcement' do
          expect {
            post :create, params: { announcement: valid_params }
          }.to change(Announcement, :count).by(1)
        end

        it 'assigns the created announcement to @announcement' do
          post :create, params: { announcement: valid_params }
          expect(assigns(:announcement)).to be_a(Announcement)
          expect(assigns(:announcement)).to be_persisted
        end

        it 'sets member_id and message_date for the new announcement' do
          post :create, params: { announcement: valid_params }
          expect(assigns(:announcement).member_id).to eq(member.id)
          expect(assigns(:announcement).message_date).to_not be_nil
        end

        it 'redirects to announcements_path with a notice' do
          post :create, params: { announcement: valid_params }
          expect(response).to redirect_to(announcements_path)
          expect(flash[:notice]).to eq('Announcement created successfully!')
        end
      end

      context 'with invalid params' do
        let(:invalid_params) { { message_title: '', message_text: '' } }

        it 'renders the new template with unprocessable_entity status' do
          post :create, params: { announcement: invalid_params }
          expect(response).to render_template :new
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  describe '#send_announcement_email' do
    it 'send the email' do
      # Call the mailer method
      AnnouncementMailer.send_announcement_email(member, announcement).deliver_now

      # Assert that the email was delivered
      expect(ActionMailer::Base.deliveries.count).to eq(1)

      # Get the delivered email
      delivered_email = ActionMailer::Base.deliveries.first

      # Assert email attributes (customize these based on your implementation)
      expect(delivered_email.subject).to eq('New Announcement from Bhakti Yoga Club!')
      expect(delivered_email.to).to eq([member.email])
      expect(delivered_email.from).to eq(['byc.notifs@gmail.com'])
      # ... other assertions based on your email content

      # Clear the deliveries array for the next test
      ActionMailer::Base.deliveries.clear
    end
  end

  describe 'POST #create' do
    before do
      sign_in member
    end

    it 'sends an announcement email' do
      # Assuming your create action sends an announcement email
      post :create, params: { announcement: valid_params }

      # Assert that the email was delivered
      expect(ActionMailer::Base.deliveries.count).to eq(1)

      # Get the delivered email and make assertions as before
      delivered_email = ActionMailer::Base.deliveries.first
      expect(delivered_email.subject).to eq('New Announcement from Bhakti Yoga Club!')
      expect(delivered_email.to).to eq([member.email])
      expect(delivered_email.from).to eq(['byc.notifs@gmail.com'])
      # ... other assertions based on your email content
    end
  end


end
