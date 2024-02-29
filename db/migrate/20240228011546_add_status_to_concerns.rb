class AddStatusToConcerns < ActiveRecord::Migration[7.0]
  def change
    add_column :concerns, :status, :string
  end
end
