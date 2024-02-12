require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      event = Event.create(name: 'Sample Event', event_date: Date.today, location: 'Sample Location')
      get :show, params: { id: event.to_param }
      expect(response).to be_successful
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new
      expect(response).to be_successful
    end
  end

  describe 'GET #edit' do
    it 'returns a success response' do
      event = Event.create(name: 'Sample Event', event_date: Date.today, location: 'Sample Location')
      get :edit, params: { id: event.to_param }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new event' do
        expect {
          post :create, params: { event: { name: 'Sample Event', event_date: Date.today, location: 'Sample Location' } }
        }.to change(Event, :count).by(1)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new event' do
        expect {
          post :create, params: { event: { name: nil, event_date: nil, location: nil } }
        }.to_not change(Event, :count)
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid parameters' do
      it 'updates the requested event' do
        event = Event.create(name: 'Sample Event', event_date: Date.today, location: 'Sample Location')
        patch :update, params: { id: event.to_param, event: { name: 'Updated Event Name' } }
        event.reload
        expect(event.name).to eq('Updated Event Name')
      end
    end

    context 'with invalid parameters' do
      it 'does not update the event' do
        event = Event.create(name: 'Sample Event', event_date: Date.today, location: 'Sample Location')
        patch :update, params: { id: event.to_param, event: { name: nil } }
        event.reload
        expect(event.name).to eq('Sample Event') # Ensure the name remains unchanged
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested event' do
      event = Event.create(name: 'Sample Event', event_date: Date.today, location: 'Sample Location')
      expect {
        delete :destroy, params: { id: event.to_param }
      }.to change(Event, :count).by(-1)
    end
  end
end