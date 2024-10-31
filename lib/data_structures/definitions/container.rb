module DataStructures
  module Definitions
    class Container
      include ActiveModel::Model
      include ActiveModel::Attributes
      attr_reader :items

      def initialize(items: [], **)
        super(**)
        @items = load_items_from items
      end

      private

      def load_items_from(config) = config.map { |item_data| DataStructures.load item_data }.freeze
    end
  end
end
