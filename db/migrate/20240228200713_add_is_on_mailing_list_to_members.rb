class AddIsOnMailingListToMembers < ActiveRecord::Migration[7.0]
  def change
    add_column :members, :is_on_mailing_list, :boolean, default: false
  end
end
