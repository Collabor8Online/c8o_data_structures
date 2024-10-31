class CreatePeople < ActiveRecord::Migration[8.0]
  def change
    create_table :people do |t|
      t.string :first_name, default: "Alice"
      t.string :last_name, default: "Aardvark"
      t.timestamps
    end
  end
end
