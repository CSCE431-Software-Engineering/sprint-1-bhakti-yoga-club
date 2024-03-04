require 'rails_helper'

RSpec.describe Event, type: :model do
  describe 'validations' do
    it 'is not valid without a name' do
      event = Event.new(start_time: DateTime.now, end_time: DateTime.now + 1.hour, location: 'Sample Location')
      expect(event).not_to be_valid
      expect(event.errors[:name]).to include("can't be blank")
    end

    it 'is not valid without a start_time' do
      event = Event.new(name: 'Sample Event', end_time: DateTime.now + 1.hour, location: 'Sample Location')
      expect(event).not_to be_valid
      expect(event.errors[:start_time]).to include("can't be blank")
    end

    it 'is not valid without an end_time' do
      event = Event.new(name: 'Sample Event', start_time: DateTime.now, location: 'Sample Location')
      expect(event).not_to be_valid
      expect(event.errors[:end_time]).to include("can't be blank")
    end

    it 'is not valid without a location' do
      event = Event.new(name: 'Sample Event', start_time: DateTime.now, end_time: DateTime.now + 1.hour)
      expect(event).not_to be_valid
      expect(event.errors[:location]).to include("can't be blank")
    end
  end
end
