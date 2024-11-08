module DataStructures
  class RepeatingGroup < Field
    def groups = fields

    def add_group
      group = definition.group
      # make sure the newly created group-field stores a definition with the next position, so it's field_name is unique
      group.position = next_position
      group.create_field(container: container, parent: self, position: next_position)
    end

    def remove_group
      groups.last.destroy if groups.size > 1
    end
  end
end
