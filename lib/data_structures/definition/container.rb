module DataStructures
  class Definition
    class Container < Definition
      attr_reader :items

      def initialize(items: [], **)
        super(**)
        @items = load_items_from items
      end

      def to_h
        super.merge("items" => items.map { |item| item.to_h })
      end

      private

      def load_items_from(config) = config.map { |item_data| DataStructures::Definition.load item_data }.freeze
    end
  end
end
