# spec/controllers/announcements_controller_spec.rb
require 'rails_helper'

RSpec.describe AnnouncementsController, type: :controller do
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
  
  describe 'DELETE #destroy' do

    announcement = Announcement.create(
      message_title: 'Test Title', 
      message_text: 'Test Text', 
      message_date: Time.current, 
      member_id: 1
    )

    it 'destroys the announcement' do
      expect {
        delete :destroy, params: { id: announcement.id }
      }.to change(Announcement, :count).by(-1)

      expect(response).to redirect_to(announcements_url)
      expect(flash[:notice]).to eq('Announcement was successfully destroyed.')
    end


  end

  describe 'PATCH #update' do

    announcement = Announcement.create(
      message_title: 'Test Title', 
      message_text: 'Test Text', 
      message_date: Time.current, 
      member_id: 1
    )

    context 'with valid parameters' do
      let(:valid_params) do
        {
          announcement: {
            message_title: 'Updated Title',
            message_text: 'Updated Text',
            message_date: Time.current,
            member_id: 1
          }
        }
      end

      it 'updates the announcement' do
        patch :update, params: { id: announcement.id, announcement: valid_params[:announcement] }

        expect(response).to redirect_to(announcements_path)
        expect(flash[:notice]).to eq('Announcement updated successfully!')
      end

    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        {
          announcement: {
            message_title: '', # Invalid title
            message_text: 'Updated Text',
            message_date: Time.current,
            member_id: 1
          }
        }
      end

      it 'does not update the announcement' do
        patch :update, params: { id: announcement.id, announcement: invalid_params[:announcement] }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:edit)
      end


    end
  end


  describe 'POST #create' do

    context 'with valid parameters' do

      it 'creates a new announcement' do

        announcement_params = {
          message_title: 'New Announcement',
          message_text: 'This is a test announcement.',
          message_date: Time.current,
          member_id: 1
        }

  
        expect do
          post :create, params: { announcement: announcement_params }
        end.to change(Announcement, :count).by(1)

        expect(response).to redirect_to(announcements_path)
        expect(flash[:notice]).to eq('Announcement created successfully!')

      end
    end

    context 'with invalid parameters' do


      let(:invalid_params) do
        {
          announcement: {
            message_title: '', # Invalid title
            message_text: 'Test Text',
            message_date: Time.current,
            member_id: 1
          }
        }
      end

      it 'does not create a new announcement' do
        expect {
          post :create, params: invalid_params
        }.not_to change(Announcement, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end

    end
  end  
end
