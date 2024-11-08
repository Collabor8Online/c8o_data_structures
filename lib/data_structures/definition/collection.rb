module DataStructures
  class Definition
    class Collection < Definition
      attr_reader :items

      def initialize(items: [], **)
        super(**)
        @items = load_items_from items
      end

      def to_h = super.merge("items" => items.map { |item| item.to_h })

      def all_items = items.flat_map { |item| item.respond_to?(:all_items) ? [item, *item.all_items] : item }

      def find(path) = all_items.find { |item| item.path == path }

      private

      def load_items_from(items)
        items.each_with_index.map { |item_data, position| DataStructures::Definition.load item_data, position: position, parent_path: path }.freeze
      end
    end
  end
end
