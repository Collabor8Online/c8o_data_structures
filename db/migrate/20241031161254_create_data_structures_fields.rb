class CreateDataStructuresFields < ActiveRecord::Migration[8.0]
  def change
    create_table :data_structures_fields, if_not_exists: true do |t|
      t.belongs_to :container, polymorphic: true
      t.string :ancestry
      t.string :type
      t.string :field_name, null: false, default: ""
      t.text :definition_configuration
      t.integer :position, null: false, default: 1
      t.text :data
      t.belongs_to :model, polymorphic: true
      t.timestamps
    end

    add_index :data_structures_fields, [:container_type, :container_id, :ancestry], if_not_exists: true
  end
end
