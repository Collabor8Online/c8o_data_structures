module DataStructures
  module Container
    extend ActiveSupport::Concern

    included do
      has_many :_items, as: :container, class_name: "DataStructures::Item", dependent: :destroy_async
      has_many :items, -> { roots.order :position }, as: :container, class_name: "DataStructures::Item"
    end

    def create_items_for definition
      items.where(position: definition.items.size..).destroy_all
      definition.items.each_with_index do |item, position|
        items.where(position: position).first_or_initialize.update! container: self, definition: item
      end
    end
  end
end
