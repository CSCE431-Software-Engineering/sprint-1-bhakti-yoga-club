# app/models/concern.rb
class Concern < ApplicationRecord
    validates :title, presence: true
    validates :description, presence: true
    
    belongs_to :member
    # Add any model validations, associations, or methods here
  end
  