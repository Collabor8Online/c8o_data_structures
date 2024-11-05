require_relative "container"

module DataStructures
  class Definition
    class Repeat < Container
      def initialize(group_items: [], **)
        super(**)
        @items = group_items
      end

      def create_item(**) = DataStructures::Repeat.create!(**)
    end
  end
end
