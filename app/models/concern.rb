# app/models/concern.rb
class Concern < ApplicationRecord
    validates :title, presence: true
    validates :description, presence: true
    
    belongs_to :member
    
    enum status: {
      unread: 'unread',
      read: 'read',
      in_progress: 'in progress',
      resolved: 'resolved'
    }

    after_initialize :set_default_status, if: :new_record?

    private

    def set_default_status
      self.status ||= :unread
    end
  end
  