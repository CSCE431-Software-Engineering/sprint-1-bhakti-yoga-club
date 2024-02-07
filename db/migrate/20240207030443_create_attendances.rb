class CreateAttendances < ActiveRecord::Migration[7.0]
  def change
    create_table :attendances do |t|
      t.references :member, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true
      t.datetime :time_arrived
      t.datetime :time_departed

      t.timestamps
    end
  end
end
