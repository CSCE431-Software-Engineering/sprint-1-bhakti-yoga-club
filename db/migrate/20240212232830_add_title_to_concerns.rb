class AddTitleToConcerns < ActiveRecord::Migration[7.0]
  def change
    add_column :concerns, :title, :string
  end
end
