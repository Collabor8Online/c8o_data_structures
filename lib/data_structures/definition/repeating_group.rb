require_relative "group"
module DataStructures
  class Definition
    class RepeatingGroup < DataStructures::Definition
      attr_reader :group_items

      def initialize(group_items: [], **)
        super(**)
        @group_items = load_group_items_from(group_items)
      end

      on_create_item do |params|
        DataStructures::RepeatingGroup.create!(**params)
      end

      def items = [group]

      def group = @group ||= Group.new(group_items: group_items)

      def to_h = super.merge("group_items" => group_items.map(&:to_h))

      private

      def load_group_items_from(config) = config.map { |item_data| DataStructures::Definition.load item_data }.freeze
    end
  end
end
