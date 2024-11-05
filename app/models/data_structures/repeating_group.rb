module DataStructures
  class RepeatingGroup < Item
    def groups = items

    def add_group = definition.group.create_item(container: container, parent: self, position: next_position)

    def remove_group
      groups.last.destroy if groups.size > 1
    end
  end
end
