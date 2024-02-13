class AddMemberIdToConcerns < ActiveRecord::Migration[7.0]
  def change
    add_reference :concerns, :member, null: false, foreign_key: true
  end
end
