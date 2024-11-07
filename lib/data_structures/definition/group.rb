require_relative "collection"

module DataStructures
  class Definition
    class Group < Collection
      self.field_class_name = "DataStructures::Group"

      def initialize(group_items: [], **)
        super(**)
        @items = group_items
      end
    end
  end
end
