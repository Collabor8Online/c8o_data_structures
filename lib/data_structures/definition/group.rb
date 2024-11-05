require_relative "container"

module DataStructures
  class Definition
    class Group < Container
      def initialize(group_items: [], **)
        super(**)
        @items = group_items
      end

      on_create_item do |params|
        DataStructures::Group.create!(**params)
      end
    end
  end
end
