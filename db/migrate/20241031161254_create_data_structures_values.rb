class CreateDataStructuresValues < ActiveRecord::Migration[8.0]
  def change
    create_table :data_structures_values, if_not_exists: true do |t|
      t.belongs_to :container, polymorphic: true
      t.string :ancestry
      t.text :definition_configuration
      t.integer :position, null: false, default: 0
      t.text :data
      t.belongs_to :model, polymorphic: true
      t.timestamps
    end

    add_index :data_structures_values, [:container_type, :container_id, :ancestry], if_not_exists: true
  end
end
