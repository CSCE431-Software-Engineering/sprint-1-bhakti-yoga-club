class AddStartAndEndDateToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :start_time, :datetime
    add_column :events, :end_time, :datetime
  end
end
