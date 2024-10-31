class CreateForms < ActiveRecord::Migration[8.0]
  def change
    create_table :forms do |t|
      t.belongs_to :person
      t.string :name
      t.timestamps
    end
  end
end
