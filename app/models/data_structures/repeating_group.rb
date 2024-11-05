module DataStructures
  class RepeatingGroup < Field
    def groups = fields

    def add_group = definition.group.create_field(container: container, parent: self, position: next_position)

    def remove_group
      groups.last.destroy if groups.size > 1
    end
  end
end
