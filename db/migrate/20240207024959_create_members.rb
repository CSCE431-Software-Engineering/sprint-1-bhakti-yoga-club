class CreateMembers < ActiveRecord::Migration[7.0]
  def change
    create_table :members do |t|
      t.string :email
      t.string :title, default: "DefaultMember"
      t.boolean :is_active_paid_member, default: false
      t.boolean :is_admin, default: false
      t.date :date_joined
      t.date :date_left

      t.timestamps
    end
  end
end
