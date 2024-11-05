require_relative "container"

module DataStructures
  class Definition
    class Group < Container
      self.field_class_name = "DataStructures::Group"

      def initialize(group_items: [], **)
        super(**)
        @items = group_items
      end
    end
  end
end
