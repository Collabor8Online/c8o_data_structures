class AddFieldNameToFields < ActiveRecord::Migration[8.0]
  def change
    add_column :data_structures_fields, :field_name, :string, null: false, default: ""
  end
end
