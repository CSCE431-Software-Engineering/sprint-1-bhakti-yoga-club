# db/migrate/20240207032038_create_announcements.rb
class CreateAnnouncements < ActiveRecord::Migration[7.0]
  def change
    create_table :announcements do |t|
      t.text :message_text
      t.datetime :message_date
      t.bigint :member_id, null: false

      t.timestamps
    end

    add_index :announcements, :member_id
  end
end
