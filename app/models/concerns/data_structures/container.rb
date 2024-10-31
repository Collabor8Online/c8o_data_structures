module DataStructures
  module Container
    extend ActiveSupport::Concern

    included do
      has_many :data_values, as: :container, class_name: "DataStructures::Value", dependent: :destroy_async
    end

    def values = data_values.roots.order :position

    def create_values_for definition
      values.where(position: definition.items.size..).destroy_all
      definition.items.each_with_index do |item, position|
        values.where(position: position).first_or_initialize.update! container: self, definition: item
      end
    end
  end
end
