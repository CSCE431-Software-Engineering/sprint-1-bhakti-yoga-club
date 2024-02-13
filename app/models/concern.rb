# app/models/concern.rb
class Concern < ApplicationRecord
    belongs_to :member
    # Add any model validations, associations, or methods here
  end
  