require_relative "collection"

module DataStructures
  class Definition
    class Group < Collection
      self.field_class_name = "DataStructures::Group"

      def initialize(group_items: nil, items: [], **)
        super(**)
        @items = group_items || load_items_from(items)
      end
    end
  end
end
