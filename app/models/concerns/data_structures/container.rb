module DataStructures
  module Container
    extend ActiveSupport::Concern

    included do
      has_many :_items, as: :container, class_name: "DataStructures::Item", dependent: :destroy_async
      has_many :items, -> { roots.order(:position) }, class_name: "DataStructures::Item", as: :container
      accepts_nested_attributes_for :items
    end

    def items= params
      puts "#{self.class}:#{id} - #{params}"
      items = params.delete(:items)
      update params
      items.collect { |param| items.find(param.delete(:_id)).items = param }
    end

    def create_items_for definition
      _items.destroy_all
      definition.items.each_with_index do |item_definition, position|
        items.find_by(position: position) || item_definition.create_item(position: position, container: self, definition: item_definition)
      end
    end
  end
end
