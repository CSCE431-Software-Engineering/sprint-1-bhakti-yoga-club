class CreateConcerns < ActiveRecord::Migration[7.0]
  def change
    create_table :concerns do |t|
      t.text :description
      t.boolean :is_read

      t.timestamps
    end
  end
end
